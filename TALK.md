# Понимаем изоляцию глобальных акторов в Swift Concurrency на примере @MainActor

## Введение

Эта статья посвящена важной теме в современной Swift-разработке — глобальным акторам и механизму изоляции, на примере популярного актера `@MainActor`. Мы разберём понятные и практичные примеры, которые помогут вам разобраться с многопоточностью и сделать код ваших приложений безопаснее.

## Что такое глобальные акторы?

Swift Concurrency принесла множество инструментов для управления многопоточностью. Среди них — глобальные акторы, которые помогают обеспечить безопасность данных и контролировать потоки выполнения. Один из самых распространённых и полезных — это `@MainActor`, который гарантирует выполнение операций в главном потоке приложения.

## Примеры использования @MainActor

### 1. Без глобальной изоляции

```swift
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS: IUpdate {
    var date: Date = .now

    func update(date: Date) async {
        await internalUpdate(date: date)
    }

    private func internalUpdate(date: Date) async {
        self.date = date
    }
}
```

**Консольный вывод:**

```
update:  <NSThread: 0x600001767e80>{number = 8, name = (null)}
internalUpdate:  <NSThread: 0x600001767e80>{number = 8, name = (null)}
didset:  <NSThread: 0x600001767e80>{number = 8, name = (null)}
```

**Вывод:** Без явной изоляции код может исполняться в любых потоках, что может привести к гонкам данных и непредсказуемому поведению приложения.

### 2. Полная изоляция на уровне типа

```swift
protocol IUpdate {
    func update(date: Date) async
}

@MainActor
@Observable
final class LS: IUpdate {
    var date: Date = .now

    func update(date: Date) async {
        await internalUpdate(date: date)
    }

    private func internalUpdate(date: Date) async {
        self.date = date
    }
}
```

**Консольный вывод:**

```
update:  <_NSMainThread: 0x600001700040>{number = 1, name = main}
internalUpdate:  <_NSMainThread: 0x600001700040>{number = 1, name = main}
didset:  <_NSMainThread: 0x600001700040>{number = 1, name = main}
```

**Вывод:** Весь код класса гарантированно исполняется в главном потоке, независимо от того, где именно реализован протокол.

### 3. Изоляция одного метода

```swift
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS: IUpdate {
    var date: Date = .now

    @MainActor
    func update(date: Date) async {
        await internalUpdate(date: date)
    }

    private func internalUpdate(date: Date) async {
        self.date = date
    }
}
```

**Консольный вывод:**

```
update:  <_NSMainThread: 0x60000170c000>{number = 1, name = main}
internalUpdate:  <NSThread: 0x600001779380>{number = 8, name = (null)}
didset:  <NSThread: 0x600001779380>{number = 8, name = (null)}
```

**Вывод:** Изолированный метод чётко выполняется на главном потоке, остальные методы могут выполняться вне главного потока.

### 4. Изоляция свойства

```swift
@Observable
final class LS: IUpdate {
    @MainActor
    var date: Date = .now

    func update(date: Date) async {
        await internalUpdate(date: date)
    }

    private func internalUpdate(date: Date) async {
        self.date = date
    }
}
```

**Консольный вывод:**

```
Compile time error: Main actor-isolated property 'date' can not be mutated from a nonisolated context
```

**Вывод:** Свойство изолировано от параллельных потоков, обеспечивая корректное состояние данных.

### 5. Полная изоляция через протокол (conformance в теле класса)

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS: IUpdate {
    var date: Date = .now

    func update(date: Date) async {
        await internalUpdate(date: date)
    }

    private func internalUpdate(date: Date) async {
        self.date = date
    }
}
```

**Консольный вывод:**

```
update:  <_NSMainThread: 0x600001700000>{number = 1, name = main}
internalUpdate:  <_NSMainThread: 0x600001700000>{number = 1, name = main}
didset:  <_NSMainThread: 0x600001700000>{number = 1, name = main}
```

**Вывод:** Полная изоляция обеспечивается через протокол — все методы исполняются строго на главном потоке.

### 6. Частичная изоляция через extension

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS {
    var date: Date = .now
}

extension LS: IUpdate {
    func update(date: Date) async {
        await internalUpdate(date: date)
    }

    private func internalUpdate(date: Date) async {
        self.date = date
    }
}
```

**Консольный вывод:**

```
update:  <_NSMainThread: 0x600001710040>{number = 1, name = main}
internalUpdate:  <NSThread: 0x60000174cd40>{number = 6, name = (null)}
didset:  <NSThread: 0x60000174cd40>{number = 6, name = (null)}
```

**Вывод:** Изолирован только метод из протокола. Внутренние методы и свойства не защищены.

### 7. Нет изоляции при реализации метода в отдельном extension

```swift
@MainActor
protocol IUpdate {
    func update(date: Date) async
}

@Observable
final class LS {
    var date: Date = .now
}

extension LS: IUpdate {}

extension LS {
    func update(date: Date) async {
        await internalUpdate(date: date)
    }

    private func internalUpdate(date: Date) async {
        self.date = date
    }
}
```

**Консольный вывод:**

```
update:  <NSThread: 0x600001776880>{number = 8, name = (null)}
internalUpdate:  <NSThread: 0x600001776880>{number = 8, name = (null)}
didset:  <NSThread: 0x600001776880>{number = 8, name = (null)}
```

**Вывод:** Несмотря на аннотацию протокола, метод не изолирован — реализация вынесена в отдельное расширение.

## Общие выводы (немного водички)

Аннотация `@MainActor` — это мощный инструмент Swift Concurrency, который позволяет повысить безопасность данных в многопоточной среде. Однако, как мы видим из приведённых кейсов, изоляция работает по-разному в зависимости от способа применения:

- Полная изоляция на уровне класса или при conform'е протокола в теле класса — надёжный способ полностью защитить объект от выполнения в фоновом потоке.
- Частичная изоляция через методы или расширения позволяет гибко управлять многопоточностью, но требует внимательности, так как не защищает всё поведение класса.
- Ошибки проектирования (например, разделение соответствия протоколу и реализации) могут привести к полной потере ожидаемой изоляции, несмотря на наличие аннотаций.

В конечном счёте, выбор подхода зависит от контекста: если объект активно взаимодействует с UI — изоляция всего класса через `@MainActor` будет наиболее надёжным решением. Если же важна производительность и есть операции, которые можно выносить в фоновый поток, стоит рассмотреть частичную изоляцию.

Главное — понимать, как работают акторы в Swift, и не надеяться на магию. Она здесь заменена строгой логикой компилятора и весьма чётким поведением.

---

**Полезные материалы:**

- [Проект на GitHub](https://github.com/ivalx1s/swift_global-actor-isolation_cases/tree/main)

**Автор:**
- Алексей Григорьев, техлид iOS-разработки продукта Membrana (Telegram: @a1exxxis)

