
# Easy Stalking

Encounter logs provide detailed combat information dumps from the ESO game client itself which can be further analyzed by third party applications.
This addon lets you configure content areas you want to automatically start logging combat data. It also disables logging whenever you're not in one of selected areas.

--------

## Features

* Option to automatically start logging in:
    * Housing
    * Arenas
    * Dungeons
    * Trials
    * Battlegrounds
    * Imperial City
    * Cyrodiil
* Optional: Get a confirmation dialog instead of logging automatically (requires LibDialog)<br>
    - Only asks in content you selected to be inteested in.<br>
    - Option to get a prompt for normal difficulty modes<br>
      - NOTE: If it is an instance you have not visited in veteran difficulty, it will prompt you regardless of your location settings
* Allows you to bind logging to a hotkey
* Visual On-Screen Indicator
* /ezlog chat command<br>
    - \<nothing\> - toggle /encounterlog, including the state of the on-screen indicator.
    - **lock** / **unlock** - lock / move the visual on-screen indicator (only if on-screen indicator is enabled)
    - **anonymous** / **named** - easy access to change your anonymity setting.

--------------

Automatic logging is disabled by default, please go to the Easy Stalking settings page and enable content types you're interested in.

-------

## Dependencies
* LibAddonMenu ( [ESOUI](https://www.esoui.com/downloads/info7-LibAddonMenu.html) | [github](https://github.com/sirinsidiator/ESO-LibAddonMenu) )
* Optional: LibDialog ( [ESOUI](https://www.esoui.com/downloads/info1931-LibDialog-Customconfirmationdialogwith2buttons.html) )