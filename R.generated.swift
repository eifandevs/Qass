//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 6 files.
  struct file {
    /// Resource file `Info.plist`.
    static let infoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "Info", pathExtension: "plist")
    /// Resource file `authorize.html`.
    static let authorizeHtml = Rswift.FileResource(bundle: R.hostingBundle, name: "authorize", pathExtension: "html")
    /// Resource file `dns.html`.
    static let dnsHtml = Rswift.FileResource(bundle: R.hostingBundle, name: "dns", pathExtension: "html")
    /// Resource file `invalid.html`.
    static let invalidHtml = Rswift.FileResource(bundle: R.hostingBundle, name: "invalid", pathExtension: "html")
    /// Resource file `offline.html`.
    static let offlineHtml = Rswift.FileResource(bundle: R.hostingBundle, name: "offline", pathExtension: "html")
    /// Resource file `timeout.html`.
    static let timeoutHtml = Rswift.FileResource(bundle: R.hostingBundle, name: "timeout", pathExtension: "html")
    
    /// `bundle.url(forResource: "Info", withExtension: "plist")`
    static func infoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.infoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "authorize", withExtension: "html")`
    static func authorizeHtml(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.authorizeHtml
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "dns", withExtension: "html")`
    static func dnsHtml(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.dnsHtml
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "invalid", withExtension: "html")`
    static func invalidHtml(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.invalidHtml
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "offline", withExtension: "html")`
    static func offlineHtml(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.offlineHtml
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "timeout", withExtension: "html")`
    static func timeoutHtml(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.timeoutHtml
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 29 images.
  struct image {
    /// Image `circlemenu_add_private`.
    static let circlemenu_add_private = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_add_private")
    /// Image `circlemenu_add`.
    static let circlemenu_add = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_add")
    /// Image `circlemenu_autoscroll`.
    static let circlemenu_autoscroll = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_autoscroll")
    /// Image `circlemenu_close`.
    static let circlemenu_close = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_close")
    /// Image `circlemenu_copy`.
    static let circlemenu_copy = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_copy")
    /// Image `circlemenu_form`.
    static let circlemenu_form = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_form")
    /// Image `circlemenu_historyback`.
    static let circlemenu_historyback = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_historyback")
    /// Image `circlemenu_historyforward`.
    static let circlemenu_historyforward = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_historyforward")
    /// Image `circlemenu_menu`.
    static let circlemenu_menu = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_menu")
    /// Image `circlemenu_search`.
    static let circlemenu_search = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_search")
    /// Image `circlemenu_url`.
    static let circlemenu_url = Rswift.ImageResource(bundle: R.hostingBundle, name: "circlemenu_url")
    /// Image `footer_back`.
    static let footer_back = Rswift.ImageResource(bundle: R.hostingBundle, name: "footer_back")
    /// Image `footer_private`.
    static let footer_private = Rswift.ImageResource(bundle: R.hostingBundle, name: "footer_private")
    /// Image `header_close`.
    static let header_close = Rswift.ImageResource(bundle: R.hostingBundle, name: "header_close")
    /// Image `header_favorite_selected`.
    static let header_favorite_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "header_favorite_selected")
    /// Image `header_favorite`.
    static let header_favorite = Rswift.ImageResource(bundle: R.hostingBundle, name: "header_favorite")
    /// Image `key`.
    static let key = Rswift.ImageResource(bundle: R.hostingBundle, name: "key")
    /// Image `logo`.
    static let logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "logo")
    /// Image `onboard_back`.
    static let onboard_back = Rswift.ImageResource(bundle: R.hostingBundle, name: "onboard_back")
    /// Image `option_menu_add`.
    static let option_menu_add = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_add")
    /// Image `option_menu_copy`.
    static let option_menu_copy = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_copy")
    /// Image `option_menu_form`.
    static let option_menu_form = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_form")
    /// Image `option_menu_help`.
    static let option_menu_help = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_help")
    /// Image `option_menu_history`.
    static let option_menu_history = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_history")
    /// Image `option_menu_initialize`.
    static let option_menu_initialize = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_initialize")
    /// Image `option_menu_mail`.
    static let option_menu_mail = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_mail")
    /// Image `option_menu_setting`.
    static let option_menu_setting = Rswift.ImageResource(bundle: R.hostingBundle, name: "option_menu_setting")
    /// Image `optionmenu_favorite`.
    static let optionmenu_favorite = Rswift.ImageResource(bundle: R.hostingBundle, name: "optionmenu_favorite")
    /// Image `optionmenu_private`.
    static let optionmenu_private = Rswift.ImageResource(bundle: R.hostingBundle, name: "optionmenu_private")
    
    /// `UIImage(named: "circlemenu_add", bundle: ..., traitCollection: ...)`
    static func circlemenu_add(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_add, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_add_private", bundle: ..., traitCollection: ...)`
    static func circlemenu_add_private(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_add_private, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_autoscroll", bundle: ..., traitCollection: ...)`
    static func circlemenu_autoscroll(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_autoscroll, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_close", bundle: ..., traitCollection: ...)`
    static func circlemenu_close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_close, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_copy", bundle: ..., traitCollection: ...)`
    static func circlemenu_copy(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_copy, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_form", bundle: ..., traitCollection: ...)`
    static func circlemenu_form(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_form, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_historyback", bundle: ..., traitCollection: ...)`
    static func circlemenu_historyback(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_historyback, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_historyforward", bundle: ..., traitCollection: ...)`
    static func circlemenu_historyforward(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_historyforward, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_menu", bundle: ..., traitCollection: ...)`
    static func circlemenu_menu(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_menu, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_search", bundle: ..., traitCollection: ...)`
    static func circlemenu_search(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_search, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "circlemenu_url", bundle: ..., traitCollection: ...)`
    static func circlemenu_url(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.circlemenu_url, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "footer_back", bundle: ..., traitCollection: ...)`
    static func footer_back(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.footer_back, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "footer_private", bundle: ..., traitCollection: ...)`
    static func footer_private(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.footer_private, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "header_close", bundle: ..., traitCollection: ...)`
    static func header_close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.header_close, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "header_favorite", bundle: ..., traitCollection: ...)`
    static func header_favorite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.header_favorite, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "header_favorite_selected", bundle: ..., traitCollection: ...)`
    static func header_favorite_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.header_favorite_selected, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "key", bundle: ..., traitCollection: ...)`
    static func key(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.key, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "logo", bundle: ..., traitCollection: ...)`
    static func logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "onboard_back", bundle: ..., traitCollection: ...)`
    static func onboard_back(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.onboard_back, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_add", bundle: ..., traitCollection: ...)`
    static func option_menu_add(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_add, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_copy", bundle: ..., traitCollection: ...)`
    static func option_menu_copy(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_copy, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_form", bundle: ..., traitCollection: ...)`
    static func option_menu_form(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_form, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_help", bundle: ..., traitCollection: ...)`
    static func option_menu_help(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_help, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_history", bundle: ..., traitCollection: ...)`
    static func option_menu_history(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_history, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_initialize", bundle: ..., traitCollection: ...)`
    static func option_menu_initialize(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_initialize, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_mail", bundle: ..., traitCollection: ...)`
    static func option_menu_mail(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_mail, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "option_menu_setting", bundle: ..., traitCollection: ...)`
    static func option_menu_setting(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.option_menu_setting, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "optionmenu_favorite", bundle: ..., traitCollection: ...)`
    static func optionmenu_favorite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.optionmenu_favorite, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "optionmenu_private", bundle: ..., traitCollection: ...)`
    static func optionmenu_private(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.optionmenu_private, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 0 reuse identifiers.
  struct reuseIdentifier {
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if UIKit.UIImage(named: "logo") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'logo' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
