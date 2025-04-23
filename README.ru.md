# Swift Concurrency: Глобальные акторы и изоляция с помощью `@MainActor`

Этот проект демонстрирует различные подходы использования глобальных акторов в Swift Concurrency на примере аннотации `@MainActor`. Каждый кейс наглядно показывает влияние изоляции акторов на выполнение кода.

## Содержание

Проект включает следующие сценарии (кейсы):

### 1. CASE_1_LS+NoGlobalActor — Отсутствие глобальной изоляции

```swift
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS: IUpdate {
    // Нет изоляции
}
```

**Заключение:**
Изоляция не применяется, операции могут выполняться в любом потоке, возможны гонки данных.

### 2. CASE_2_LS+IsolationOnTypeDeclaration — Изоляция на уровне типа

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@MainActor
@Observable
final class LS: IUpdate {
    // Полная изоляция
}
```

**Заключение:**
Полная изоляция: все методы и свойства выполняются в главном акторе (главном потоке). Изоляция полная независимо от реализации протокола в объявлении типа или расширении.

### 3. CASE_3_LS+IsolationOnTypeFunction — Изоляция метода

```swift
@Observable
final class LS: IUpdate {
    @MainActor
    func update(date: Date) async {
        // изолированный метод
    }
}
```

**Заключение:**
Изолирован только аннотированный метод `update`, остальные методы без изоляции.

### 4. CASE_4_LS+IsolationOnTypeField — Изоляция свойства

```swift
@Observable
final class LS: IUpdate {
    @MainActor
    var date: Date = .now
}
```

**Заключение:**
Свойство `date` изолировано, и его нельзя изменить из неизолированного контекста.

### 5. CASE_5_LS+IsolationOnProtocol_ProtocolOnTypeDeclaration — Полная изоляция через протокол

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS: IUpdate {
    func update(date: Date) async {
        // полная изоляция
    }
}
```

**Заключение:**
Полная изоляция через соответствие протоколу; все методы протокола выполняются в главном акторе.

### 6. CASE_6_LS+IsolationOnProtocol_ProtocolOnExtension_WithImplementation — Частичная изоляция через расширение протокола

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS {}

extension LS: IUpdate {
    func update(date: Date) async {
        // изолированный метод протокола
    }
}
```

**Заключение:**
Изолированы только методы протокола, реализованные в расширении. Остальные методы неизолированы.

### 7. CASE_7_LS+IsolationOnProtocol_ProtocolOnExtension_ImplementationInAnotherExt — Отсутствие изоляции (реализация в другом расширении)

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS {}

extension LS: IUpdate {}

extension LS {
    func update(date: Date) async {
        // нет изоляции
    }
}
```

**Заключение:**
Изоляция отсутствует, так как соответствие протоколу и реализация методов находятся в разных расширениях.

### 8. CASE_8_LS+IsolationOnType_EmbeddedTypeNotIsolated — Вложенные типы не изолированы

```swift
@MainActor
@Observable
final class LS {
    var date: Date = .now {
        didSet {
            print("didset: ", Thread.current)
        }
    }

    enum EmbeddedType {
        static func printEmbeddedTypeThread() {
            print("embedded type sync call: ", Thread.current)
        }

        static func printEmbeddedTypeThreadAsync() async {
            print("embedded type async call: ", Thread.current)
        }
    }
}

extension LS: IUpdate {
    func update(date: Date) async {
        print("update: ", Thread.current)
        await internalUpdate(date: date)
        EmbeddedType.printEmbeddedTypeThread()
        await EmbeddedType.printEmbeddedTypeThreadAsync()
    }

    private func internalUpdate(date: Date) async {
        print("internalUpdate: ", Thread.current)
        self.date = date
    }
}
```

**Заключение:**
Изоляция распространяется только на основной тип. Вложенные типы не получают изоляцию:
- Синхронные вызовы выполняются в потоке вызывающего кода.
- Асинхронные — не изолированы и могут быть выполнены в произвольном потоке.
- Расположение вложенного типа (в теле класса или в extension) не влияет на поведение.

## Как использовать

- Откройте проект в Xcode.
- Перейдите в папку `CASES`.
- Раскомментируйте интересующий вас кейс.
- Запустите приложение.
- Проверьте вывод консоли, чтобы увидеть контекст выполнения и поведение потоков.

## Вывод консоли
Каждый кейс сопровождается комментариями о выводе в консоль, демонстрирующими выполнение потоков и изоляцию.

## Итоговые выводы

- Полная изоляция гарантирует выполнение всего кода в главном потоке.
- Частичная изоляция гибкая, но требует осторожности.
- Отсутствие изоляции может привести к гонкам данных.
- Вложенные типы не изолируются автоматически — следует быть внимательными при использовании async-кода внутри них.

Используйте проект как наглядное руководство по работе с глобальными акторами в Swift Concurrency.

Используйте проект как наглядное руководство по работе с глобальными акторами в Swift Concurrency.
