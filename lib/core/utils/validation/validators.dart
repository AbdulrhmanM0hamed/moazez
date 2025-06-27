class AppValidators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال عنوان المهمة';
    }
    if (value.length < 3) {
      return 'العنوان يجب أن يكون 3 أحرف على الأقل';
    }
    if (value.length > 50) {
      return 'العنوان طويل جداً';
    }
    return null;
  }

  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال قيمة';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال وصف المهمة';
    }
    if (value.length < 10) {
      return 'الوصف يجب أن يكون 10 أحرف على الأقل';
    }
    if (value.length > 500) {
      return 'الوصف طويل جداً (الحد الأقصى 500 حرف)';
    }
    return null;
  }

  static String? validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال المدة';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'الرجاء إدخال رقم صحيح';
    }
    if (number <= 0) {
      return 'المدة يجب أن تكون يوماً واحداً على الأقل';
    }
    if (number > 200) {
      return 'المدة يجب ألا تتجاوز 200 يوم';
    }
    return null;
  }

  static String? validateRewardAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال القيمة';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'الرجاء إدخال مبلغ صحيح';
    }
    if (number <= 0) {
      return 'المبلغ يجب أن يكون أكبر من صفر';
    }
    if (number > 1000000) {
      return 'المبلغ كبير جداً (الحد الأقصى مليون)';
    }
    return null;
  }

  static String? validateRewardDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال وصف المكافأة';
    }
    if (value.length < 5) {
      return 'الوصف يجب أن يكون 5 أحرف على الأقل';
    }
    if (value.length > 500) {
      return 'الوصف طويل جداً (الحد الأقصى 500 حرف)';
    }
    return null;
  }
}
