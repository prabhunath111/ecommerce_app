# Clean Architecture & Feature-First Rules

## Principles
1. **Separation of Concerns**: Keep domain entities and business logic free of UI, Dio, and GetX dependencies.
2. **Dependency Rule**: Dependencies point inwards. Domain depends on nothing; Data and Presentation depend on Domain.
3. **Repository Pattern**: Domain declares abstract repository interfaces; Data provides concrete implementations returning `Either<Failure, T>`.
4. **Single Responsibility Use Cases**: Every use case represents one business action (e.g. `AddToCartUseCase`, `LoginUseCase`).
5. **Dependency Injection**: Use `GetIt` for registering service singletons and repositories.
