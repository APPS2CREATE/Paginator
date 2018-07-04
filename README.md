# Paginator

[![Version](https://img.shields.io/cocoapods/v/Paginator.svg?style=flat)](https://cocoapods.org/pods/Paginator)
[![License](https://img.shields.io/cocoapods/l/Paginator.svg?style=flat)](https://cocoapods.org/pods/Paginator)
[![Platform](https://img.shields.io/cocoapods/p/Paginator.svg?style=flat)](https://cocoapods.org/pods/Paginator)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

===============================================================================

The controllers implemented in the pagingViewController do need to conform to the Pageable protocol.
```swift
class ViewControllerOne: UIViewController, Pageable {

    // MARK: - Paging implicit properties

    var pageTitle: String {
        return "vcOne"
    }

    func pagingViewDidShow() {
        textfield.becomeFirstResponder()
    }
}
```

To implement this in your base viewController:
```swift
    /// This function is used to only at the pagingView (top bar),
    /// with an amount of titles given to it.
    func exampleAddingOnlyThePagingView() {
        // PagingView titles
        let pagingView = PagingView(titles: ["Red", "Gray", "Blue"])

        // PagingView Delegate
        pagingView.delegate = self

        // Add pagingView
        pagingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pagingView)

        // give the pagingView some contstraints
        pagingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        pagingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pagingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pagingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    /// Here we instantiate some viewControllers, and show the pagingViewController with the initialized viewControllers.
    /// We can add this PagingViewController to a containerView so we have a baseController that is in control of the pagingViewController.
    func exampleAddingThePagingViewController() {
        let controller1 = ViewControllerOne()
        let controller2 = ViewControllerTwo()
        let controller3 = ViewControllerThree()

        let controller = PagingViewController(viewControllers: [controller1, controller2, controller3], initialIndex: 0)
        self.present(controller, animated: true, completion: nil)
    }
```

## Installation

Paginator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ADPaginator'
```

## Contributing

For those who want to contribute, please create feature branches on develop and create a Pull Request when done. We will work with a release 'Master' and beta 'Beta' branch.

## Author

AdamsDevelopment, s.adams@hotmail.be

## License

Paginator is available under the MIT license. See the [LICENSE](https://github.com/AdamsDevelopment/Paginator/blob/master/LICENSE) file for more info.
