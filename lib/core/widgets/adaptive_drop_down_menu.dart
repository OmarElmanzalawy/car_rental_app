import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AdaptiveDropDownItem<T> {
  final T value;
  final String label;
  final bool enabled;

  const AdaptiveDropDownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });
}

class AdaptiveDropDownMenu<T> extends StatelessWidget {
  const AdaptiveDropDownMenu({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.hintText,
    this.enabled = true,
    this.width,
    this.leadingIcon,
  });

  final List<AdaptiveDropDownItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? label;
  final String? hintText;
  final bool enabled;
  final double? width;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (context, platform) {
        return DropdownMenu<T>(
          enabled: enabled,
          width: width,
          label: label != null ? Text(label!) : null,
          hintText: hintText,
          leadingIcon: leadingIcon,
          initialSelection: value,
          dropdownMenuEntries: items
              .map(
                (e) => DropdownMenuEntry<T>(
                  value: e.value,
                  label: e.label,
                  enabled: e.enabled,
                ),
              )
              .toList(),
          onSelected: enabled ? onChanged : null,
        );
      },
      cupertino: (context, platform) {
        final enabledItems = items.where((e) => e.enabled).toList();

        final selectedLabel = items
            .cast<AdaptiveDropDownItem<T>?>()
            .firstWhere(
              (e) => e?.value == value,
              orElse: () => null,
            )
            ?.label;

        final displayText = selectedLabel ?? hintText ?? '';

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: !enabled || enabledItems.isEmpty
              ? null
              : () {
                  final initialIndex = value == null
                      ? 0
                      : enabledItems.indexWhere((e) => e.value == value);
                  int tempIndex = initialIndex < 0 ? 0 : initialIndex;

                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            height: 320,
                            color: CupertinoColors.systemBackground.resolveFrom(
                              context,
                            ),
                            child: SafeArea(
                              top: false,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 44,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        CupertinoButton(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                              ),
                                          onPressed: () {
                                            onChanged(
                                              enabledItems[tempIndex].value,
                                            );
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Done'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                            initialItem: tempIndex,
                                          ),
                                      itemExtent: 40,
                                      onSelectedItemChanged: (index) {
                                        setState(() {
                                          tempIndex = index;
                                        });
                                      },
                                      children: enabledItems
                                          .map(
                                            (e) => Center(
                                              child: Text(
                                                e.label,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.secondarySystemGroupedBackground
                  .resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.separator.resolveFrom(context),
              ),
            ),
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      color: selectedLabel == null
                          ? CupertinoColors.placeholderText.resolveFrom(context)
                          : CupertinoColors.label.resolveFrom(context),
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
