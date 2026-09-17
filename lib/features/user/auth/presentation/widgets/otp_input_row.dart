import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class OtpInputRow extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputRow({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputRow> createState() => OtpInputRowState();
}

class OtpInputRowState extends State<OtpInputRow> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get code => _controllers.map((c) => c.text).join();

  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
    widget.onChanged?.call('');
    setState(() {});
  }

  void _notify() {
    final value = code;
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      widget.onCompleted(value);
    }
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      final chars = value.replaceAll(RegExp(r'\D'), '').split('');
      for (var i = 0; i < widget.length; i++) {
        _controllers[i].text = i < chars.length ? chars[i] : '';
      }
      final nextIndex = chars.length >= widget.length
          ? widget.length - 1
          : chars.length;
      _focusNodes[nextIndex].requestFocus();
      _notify();
      setState(() {});
      return;
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _notify();
    setState(() {});
  }

  KeyEventResult _onKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _notify();
      setState(() {});
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (index) {
          final filled = _controllers[index].text.isNotEmpty;
          return SizedBox(
            width: 46.w,
            height: 56.h,
            child: Focus(
              onKeyEvent: (_, event) => _onKey(index, event),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: filled
                      ? AppColors.secondary.withValues(alpha: 0.12)
                      : AppColors.surface,
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                    borderSide: BorderSide(
                      color: filled ? AppColors.secondary : AppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                    borderSide: const BorderSide(
                      color: AppColors.secondary,
                      width: 1.6,
                    ),
                  ),
                ),
                onChanged: (value) => _onChanged(index, value),
              ),
            ),
          );
        }),
      ),
    );
  }
}
