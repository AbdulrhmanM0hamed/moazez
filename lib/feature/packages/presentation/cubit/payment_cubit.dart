import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/packages/domain/usecases/initiate_payment_usecase.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_state.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_cubit.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;
  bool _isProcessing = false;
  
  // إضافة مراجع للكيوبت الأخرى
  SubscriptionCubit? _subscriptionCubit;
  PackageCubit? _packageCubit;

  PaymentCubit({required this.initiatePaymentUseCase})
    : super(PaymentInitial());
    
  // تعيين مراجع للكيوبت الأخرى
  void setSubscriptionCubit(SubscriptionCubit cubit) {
    _subscriptionCubit = cubit;
  }
  
  void setPackageCubit(PackageCubit cubit) {
    _packageCubit = cubit;
  }

  // تتبع محاولات الدفع لنفس الباقة
  int _retryCount = 0;
  int? _lastPackageId;
  DateTime? _lastAttemptTime;
  
  // تتبع خطأ 429
  DateTime? _lastRateLimitError;
  bool _isRateLimited = false;
  
  // التحقق مما إذا كان المستخدم في فترة الانتظار بعد خطأ 429
  bool get isRateLimited {
    if (!_isRateLimited || _lastRateLimitError == null) return false;
    
    final now = DateTime.now();
    final timeSinceError = now.difference(_lastRateLimitError!);
    
    // إذا مر أكثر من 5 دقائق منذ آخر خطأ، نعيد تعيين حالة التقييد
    if (timeSinceError.inMinutes >= 5) {
      _isRateLimited = false;
      return false;
    }
    
    return true;
  }
  
  // الحصول على الوقت المتبقي للانتظار بالثواني
  int get remainingCooldownSeconds {
    if (!_isRateLimited || _lastRateLimitError == null) return 0;
    
    final now = DateTime.now();
    final timeSinceError = now.difference(_lastRateLimitError!);
    final remainingSeconds = (5 * 60) - timeSinceError.inSeconds;
    
    return remainingSeconds > 0 ? remainingSeconds : 0;
  }
  
  Future<void> initiatePayment(int packageId) async {
    // التحقق من حالة المعالجة الحالية
    if (_isProcessing) {
      emit(
        PaymentError(message: 'يرجى الانتظار، جارٍ معالجة طلب الدفع السابق'),
      );
      return;
    }
    
    // التحقق من حالة تقييد المعدل (Rate Limit)
    if (isRateLimited) {
      final remainingMinutes = (remainingCooldownSeconds / 60).ceil();
      emit(PaymentError(
        message: 'لقد قمت بالعديد من المحاولات. يرجى الانتظار لمدة $remainingMinutes دقائق قبل المحاولة مرة أخرى.',
      ));
      return;
    }
    
    // التحقق من تكرار المحاولات على نفس الباقة
    final now = DateTime.now();
    if (_lastPackageId == packageId) {
      // إذا كانت هناك محاولة سابقة لنفس الباقة
      if (_lastAttemptTime != null) {
        final timeSinceLastAttempt = now.difference(_lastAttemptTime!);
        
        // إذا كانت المحاولة السابقة حديثة جدًا (أقل من 5 ثوانٍ)
        if (timeSinceLastAttempt.inSeconds < 5) {
          _retryCount++;
          
          // إذا كان هناك محاولات متكررة كثيرة، نطلب من المستخدم الانتظار لفترة أطول
          if (_retryCount > 2) {
            emit(PaymentError(
              message: 'يرجى الانتظار لمدة 30 ثانية قبل إعادة المحاولة مرة أخرى',
            ));
            return;
          }
        } else if (timeSinceLastAttempt.inSeconds > 30) {
          // إعادة تعيين العداد إذا مر وقت كافٍ
          _retryCount = 0;
        }
      }
    } else {
      // باقة جديدة، إعادة تعيين العداد
      _retryCount = 0;
      _lastPackageId = packageId;
    }
    
    // تحديث وقت آخر محاولة
    _lastAttemptTime = now;
    _isProcessing = true;
    emit(PaymentLoading());
    
    // إضافة تأخير أطول لمنع الطلبات المتكررة السريعة
    await Future.delayed(Duration(seconds: 3));
    
    // التحقق مما إذا تم بدء طلب آخر
    if (!_isProcessing) return;
    
    debugPrint('[PaymentCubit] Initiating payment for packageId: $packageId, retry count: $_retryCount');
    final result = await initiatePaymentUseCase(packageId);
    
    result.fold(
      (failure) {
        _isProcessing = false;
        
        // التحقق من نوع الخطأ
        if (failure.message.contains('تجاوز الحد المسموح') || 
            failure.message.contains('لقد قمت بالعديد من المحاولات') ||
            failure.message.contains('429')) {
          // تعيين حالة تقييد المعدل وتسجيل وقت الخطأ
          _isRateLimited = true;
          _lastRateLimitError = DateTime.now();
          
          debugPrint('[PaymentCubit] Rate limit error detected. Cooldown period started.');
          
          emit(PaymentError(
            message: 'لقد قمت بالعديد من المحاولات. يرجى الانتظار لمدة 5 دقائق قبل المحاولة مرة أخرى.',
          ));
        } else {
          emit(PaymentError(
            message: failure.message,
          ));
        }
      },
      (response) {
        _isProcessing = false;
        _retryCount = 0; // إعادة تعيين العداد عند النجاح
        emit(PaymentSuccess(paymentUrl: response['payment_url'] as String?));
      },
    );
  }
  
  // تحديث حالة الاشتراك بعد الدفع الناجح
  void updateSubscriptionAfterPayment() {
   // debugPrint('[PaymentCubit] Updating subscription status after successful payment');
    
    // تحديث حالة الاشتراك الحالي
    if (_subscriptionCubit != null) {
      _subscriptionCubit!.fetchCurrentSubscription();
    } else {
   //   debugPrint('[PaymentCubit] Warning: SubscriptionCubit not set');
    }
    
    // تحديث قائمة الباقات
    if (_packageCubit != null) {
      _packageCubit!.getPackages();
    } else {
   //   debugPrint('[PaymentCubit] Warning: PackageCubit not set');
    }
  }
}
