//
//  OptionalPicker.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import SwiftUI

/// A control for selecting one of several options, or nothing.
///
/// You can create an `OptionalPicker` by providing a selection binding, a label, and the content for
/// the picker to display. Set the `selection` parameter to a bound, optional property. The label should
/// be set to a view that visually describes the purpose of selecting content in the picker. A label for the
/// case where the selected property is `nil` may also be provided.
///
/// Unlike a standard `Picker`, `OptionalPicker`works on the basis that the selected item is one
/// of the provided collection. This means that the object in the `selection` binding must conform to
/// both `Hashable` (so it is useable as a tag within the picker) and `Identifiable`.
public struct OptionalPicker<
    Title: View,
    Data: RandomAccessCollection<Item>,
    Item: Identifiable & Hashable,
    Label: View
>: View {
    private var title: () -> Title
    private var whenNone: LocalizedStringKey
    private var items: Data
    @Binding private var selection: Item?
    private var label: (Item) -> Label

    /// Create an OptionalPicker
    ///
    /// - Parameters:
    ///   - items: A collection of objects to pick from
    ///   - selection: A binding to a propetry that determines the currently selected option (or none)
    ///   - whenNone: The text to display for the option for no selection. Defaults to `"None"`
    ///   - label: A view that presents each option.
    ///   - title: A view that describes the purpose of selecting an option.
    public init(
        _ items: Data,
        selection: Binding<Item?>,
        whenNone: LocalizedStringKey = "None",
        label: @escaping (Item) -> Label,
        title: @escaping () -> Title
    ) {
        self.items = items
        self._selection = selection
        self.whenNone = whenNone
        self.label = label
        self.title = title
    }

    public var body: some View {
        Picker(
            selection: $selection,
            content: {
                Text(whenNone)
                    .tag(nil as Item?)
                ForEach(items) { item in
                    label(item).tag(item as Item?)
                }
            },
            label: title
        )
    }
}

public extension OptionalPicker {
    /// Create an OptionalPicker
    ///
    /// - Parameters:
    ///   - title: A localized string key that describes the purpose of selecting an option.
    ///   - items: A collection of objects to pick from.
    ///   - selection: A binding to a property that determines the currently selected option (or none).
    ///   - whenNone: The text to display for the option for no selection. Defaults to `"None"`
    ///   - label: A view that presents each option.
    init(
        _ titleKey: LocalizedStringKey,
        _ items: Data,
        selection: Binding<Item?>,
        whenNone: LocalizedStringKey = "None",
        label: @escaping (Item) -> Label
    ) where Title == Text {
        self.init(
            items,
            selection: selection,
            whenNone: whenNone,
            label: label,
            title: { Text(titleKey) }
        )
    }

    /// Create an OptionalPicker with each item represented by one of its text properties
    ///
    /// This initialize creates a `Text` view for each item in the picker, using the value of the
    /// provided keyPath. For example, passing `keyPath: \.name` is equivalent to providing
    /// a view of `Text(item.name)`.
    ///
    /// - Parameters:
    ///   - items: A collection of objects to pick from.
    ///   - selection: A binding to a property that determines the currently selected option (or none).
    ///   - whenNone: The text to display for the option for no selection. Defaults to `"None"`
    ///   - keyPath: A key path that resolves to a `String` property on each item.
    ///   - title: A view describing the purpose of selecting an object.
    init(
        _ items: Data,
        selection: Binding<Item?>,
        whenNone: LocalizedStringKey = "None",
        keyPath: KeyPath<Item, String>,
        title: @escaping () -> Title
    ) where Label == Text {
        self.init(
            items,
            selection: selection,
            whenNone: whenNone,
            label: { Text($0[keyPath: keyPath]) },
            title: title
        )
    }

    /// Create an OptionalPicker with each item represented by one of its text properties
    ///
    /// This initialize creates a `Text` view for each item in the picker, using the value of the
    /// provided keyPath. For example, passing `keyPath: \.name` is equivalent to providing
    /// a view of `Text(item.name)`.
    ///
    /// - Parameters:
    ///   - title: A localized string key that described the purpose of selecting an option.
    ///   - items: A collection of objects to pick from.
    ///   - selection: A binding to a property that determines the currently selected option (or none).
    ///   - whenNone: The text to display for the option for no selection. Defaults to `"None"`
    ///   - keyPath: A key path that resolves to a `String` property on each item
    init(
        _ titleKey: LocalizedStringKey,
        _ items: Data,
        selection: Binding<Item?>,
        whenNone: LocalizedStringKey = "None",
        keyPath: KeyPath<Item, String>
    ) where Title == Text, Label == Text {
        self.init(
            items,
            selection: selection,
            whenNone: whenNone,
            keyPath: keyPath,
            title: { Text(titleKey) }
        )
    }
}

struct OptionalPicker_Previews: PreviewProvider {
    struct Person: Identifiable, Hashable {
        var id = UUID()
        var name: String

        init(_ name: String, id: UUID = UUID()) {
            self.id = id
            self.name = name
        }

        static var people: [Person] = {
            [
                Person("Alfred"),
                Person("Brianna"),
                Person("Charlie"),
                Person("Derek"),
                Person("Erica"),
                Person("Freddie"),
                Person("Gina"),
                Person("Helena")
            ]
        }()
    }

    struct Preview: View {
        @State private var person: Person?

        var body: some View {
            NavigationStack {
                Form {
                    OptionalPicker("Person", Person.people, selection: $person) { person in
                        Label(person.name, systemImage: "person")
                    }
                    OptionalPicker(Person.people, selection: $person, keyPath: \.name) { Label("Person", systemImage: "person") }
                        .pickerStyle(.navigationLink)
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
