# MUI
MUI is a UI Libarary / Framework that doesn't suck. It offers Custom Elements with just vanilla JavaScript & CSS and nothing else,
no shadow dom, no scoped style, no voodoo nor magic, and still works in every modern browser.


[![Selenium Test Status](https://saucelabs.com/buildstatus/gdotdesign)](https://saucelabs.com/u/gdotdesign)
[![Build Status](https://travis-ci.org/gdotdesign/mui.png?branch=master)](https://travis-ci.org/gdotdesign/mui)

## Basic concepts
* Exetensible
* Simple
* Only Custom Elements ( no input, textarea, select, etc...)
* Modular
* Keyboard Support (v0.3.0)
* Touch Support (v0.2.0)
* Same Look and Feel everywhere
* Test (CI)
* Modern

## Guidelines
If you want to create a new (not existing) component, these are the guidelines to follow:
* Every component **must** be implemented in *CoffeeScript*.
* Every component **must** implement a `disabled` state.
* Every component **must** implement a public **API**.
* Every component **must** be tested extensivly.
* Every component **must** be documented.
* Every component **must** use the `UI.Events` *event types*.
* Every component **must** extend either `UI.Abstract` or an other component.
* Every component **must** be skinned at least in one theme.
* A component in `disabled` state can **only** be manipulated with the **API** (not with user interaction).
* A component **should not** leak 
* A component **must not** use CSS classes for control.
* A component **should** use attributes for control.
* A component which implements properties **must** use the `@get` and `@set` property constructors.
* Any CSS references to an other component **must** be made with `SELECTOR` method:   
  `@button = @querySelector(UI.Button.SELECTOR())`

## Contributing
You can contribute by:
* Creating new a Component
  * Fork the repo
  * Create component
  * Create tests and documentation
  * Create a pull request
  * The Component will be reviewed and accepted if it meets the Guidelines.
* Submitting / Fixing bugs
* Testing MUI in real world projects
* Publishing articles about MUI (tutorials, reviews, comparissons, etc...)
* Staring this repo
* Sharing this repo
  
## Browser Support
* IE9+
* Chrome
* Firefox
* Safari
* Opera
* Android(4+)
* iOS
