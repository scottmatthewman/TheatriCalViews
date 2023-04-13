# TheatriCalViews

A collection of generic views used within the TheatriCal app.

## Criteria for inclusion

Each view should conform to the following criteria:

- No reliance on, or assumption of, TheatriCal data models
- Ideally, no dependence on other SDKs, whether Apple-provided (e.g., `Contacts`, `EventKit`) or third party

## Available views

* `CardView`

  A card comprising an image on top, and some custom view underneath
  
* `OptionalPicker`

  A `Picker` specifically designed to work with collections of selectable objects, and which support a `nil` selection
  
* `ImagePicker`

  A `PhotoPicker` implementation which displays a selection button when no photo is selected. Once a photo is selected, the image is displayed with a clear button to remove it.
  
  Dependency: **PhotosUI**
  
* `URLField`

  A `TextField` geared to support URL entry, using UIKit's URL keyboard and content types. A `PasteButton` may be optionally displayed to copy URLs from the clipboard.

* `DetailSection`

  A custom `DisclosureGroup` with optional support for an additional button within the group header. 
