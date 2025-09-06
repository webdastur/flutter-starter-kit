import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_dimensions.dart';
import '../../../domain/entities/todo_entity.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoEntity todo;
  final ValueChanged<TodoEntity> onToggle;
  final ValueChanged<TodoEntity> onDelete;
  final ValueChanged<TodoEntity>? onEdit;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingHorizontal,
        vertical: AppDimensions.spacingXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      elevation: AppDimensions.cardElevation,
      child: Container(
        constraints: BoxConstraints(
          minHeight: AppDimensions.listItemHeightCompact,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.listItemPadding,
            vertical: AppDimensions.spacingSm,
          ),
          leading: Transform.scale(
            scale: 1.2.sp,
            child: Checkbox(
              value: todo.completed,
              onChanged: (_) => onToggle(todo),
              activeColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
            ),
          ),
          title: Text(
            todo.todo,
            style: TextStyle(
              decoration: todo.completed ? TextDecoration.lineThrough : null,
              color: todo.completed ? Colors.grey[600] : null,
              fontSize: AppTypography.bodyLarge,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: AppDimensions.spacingXs),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.xs,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: todo.completed
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                  child: Text(
                    todo.completed
                        ? 'todos.completed'.tr()
                        : 'todos.pending'.tr(),
                    style: TextStyle(
                      color: todo.completed
                          ? Colors.green[700]
                          : Colors.orange[700],
                      fontSize: AppTypography.labelSmall,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.sm),
                Text(
                  'User: ${todo.userId}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: AppTypography.labelSmall,
                  ),
                ),
              ],
            ),
          ),
          trailing: SizedBox(
            width: AppDimensions.isCompactPhone ? 70.w : 90.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (AppDimensions.isLargePhone)
                  Padding(
                    padding: EdgeInsets.only(right: AppDimensions.xs),
                    child: Text(
                      'ID: ${todo.id}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: AppTypography.labelSmall,
                      ),
                    ),
                  ),
                if (onEdit != null)
                  SizedBox(
                    width: 20.w,
                    // height: .w,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: AppDimensions.iconSm,
                      ),
                      color: Colors.blue[400],
                      onPressed: () => onEdit!(todo),
                      tooltip: 'Edit todo',
                    ),
                  ),
                SizedBox(
                  width: 20.w,
                  // height: 8.w,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.delete_outline,
                      size: AppDimensions.iconSm,
                    ),
                    color: Colors.red[400],
                    onPressed: () => onDelete(todo),
                    tooltip: 'Delete todo',
                  ),
                ),
              ],
            ),
          ),
          onTap: () => onToggle(todo),
        ),
      ),
    );
  }
}
