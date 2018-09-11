Numpad Remap

Todo
- [ ] Delete cruft & commit
- [ ] Hide on restart
- [ ] Delete Icon size selection code
- [ ] Program key via right click
- [ ] Load key from key layout history
- [ ] Preference to not hide app on deactivation

Letter Responder
- [ ] Need first responder to accumulate key presses in text field
- [ ] Then if there is a uniquely resolvable set of keys launch matching app, escape to clear
- [ ] Preference to resolve app on first letter
- [ ] Preference to prefer open apps, then prefer frequently used apps

3 Views
- [ ] Contain keypad in view that can contain multiple keypads
	- [ ] Create view that can contain multiple keypads
	- [ ] Insert that into hierarchy of views in-between contentView and keypad view
- [ ] Containing view responds to key presses to switch them out
- [ ] ViewModel update for apps ordered by favorites

Todo [Features]
- [x] App autolaunches on restart
	- [x] Implement
	- [x] Test
- [ ] Multiple app activation changes app picker
    - [ ] Recent -> Favorites -> Letters

Todo [Keyboard Support]
- [ ] Way to manage shortcuts

Todo [About]
- [ ] About information
- [ ] TextView of acknowledgements or link to file?

Todo [Refactor]
- [ ] Use NSButton to draw icons (NSButton & NSButtonCell.imageScaling)

Todo [Preferences]

Todo [Performance]
- [ ] What's app doing when in background, is it still updating views?
- [ ] Faster app window switching (how does apple+tab switch so fast?)
- [ ] Faster app loading (how to get app into responsive state faster?)

Todo [Fastlane]
- [ ] Run tests via fastlane
- [ ] Build release via fastlane

Todo [Bugs]
- [ ] First launch doesn't show app icons
- [ ] Numpad model probably shouldn't be making MASShortcuts
- [ ] Cannot restore user defaults to default state
- [ ] Fix window jitter on appearance
- [ ] Numpad loses first responder (see Flying Fingers solution to fix)

Todo [Release]
- [ ] Make sure licenses are correct and included
- [ ] (https://www.bignerdranch.com/blog/using-cocoapods-without-going-court/)
