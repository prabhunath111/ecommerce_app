# GetX GetBuilder with ID Standards

1. **Explicit IDs**: Every reactive widget must be wrapped in `GetBuilder<T>(id: TargetId, builder: (controller) => ...)`
2. **Selective Updates**: In controllers, call `update([TargetId])` targeting only affected widgets.
3. **Identifier Constants**: All IDs must be referenced from `core/constants/get_builder_ids.dart`.
4. **Lifecycle**: Use `onInit` and `onClose` in `GetxController` for setup and resource cleanup.
