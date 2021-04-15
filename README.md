# subtitle_wrapper_package

[![](https://img.shields.io/badge/pub-v2.0.1-brightgreen.svg)](https://pub.dev/packages/subtitle_wrapper_package)

[![Test and (dry-run) publish package](https://github.com/Joran-Dob/flutter_subtitle_wrapper/actions/workflows/flutter-drive.yml/badge.svg)](https://github.com/Joran-Dob/flutter_subtitle_wrapper/actions/workflows/flutter-drive.yml)

[![codecov](https://codecov.io/gh/Joran-Dob/flutter_subtitle_wrapper/branch/master/graph/badge.svg)](https://codecov.io/gh/Joran-Dob/flutter_subtitle_wrapper)
[![licence](https://img.shields.io/badge/licence-MIT-blue.svg)](https://github.com/IamTobi/spotify_sdk/blob/master/LICENSE)

## Features

Subtitle playback for the 2 most widely used subtitle formats are supported currently which can be dynamicly updated during playback from a url of content string. As well as basic styling of the subtitle text item.

The package is nearly completely unit tested and widget tests are in progress.

| Function  | Description| Implemented |
|---|---|---|
| Parse WebVTT  | Parsing of WebVtt subtitles. | ✔ |
| Parse SubRip (.srt)  | Parsing of SubRip subtitles. | ✔ |
| Remote loading utf8 encoded subtitles  | The parsing of subtitle files with the utf8 encoding from an url.| ✔ |
| Remote loading latin1 encoded subtitles  |The parsing of subtitle files with the latin1 encoding from an url. | ✔ |
| Dynamic updating of subtitle  | Update subtitle content during playback. | ✔ |
| Standard subtitle styling  | Standard styling of subtitle items. | ✔ |
| Advance subtitle styling  | Advance styling of subtitle items. Like custom fonts.| 🚧 |

## Installation

The basic setup of the package is really straight forward, create a instance of `SubtitleController` with a `subtitleUrl` or `subtitlesContent` depending if your resource is remote or local. 

Unfortunately currently its required to specify the subtitle type so `webvtt` or `srt` .

After this you need to wrap your video player with the `SubTitleWrapper` and add the `SubtitleController` and `videoPlayerController` to the `SubTitleWrapper` . That's it :tada:

``` dart
 final SubtitleController subtitleController = SubtitleController(
    subtitleUrl: "https://pastebin.com/raw/ZWWAL7fK",
    subtitleType: SubtitleType.webvtt,
  );
  
 SubTitleWrapper(
       videoPlayerController: videoPlayerController,
       subtitleController: subtitleController,
       subtitleStyle: SubtitleStyle(
         textColor: Colors.white,
         hasBorder: true,
       ),
       videoChild: Chewie(
         controller: chewieController,
       ),
	),
```

## Example

Demonstrates how to use the subtitle_wrapper_package plugin.

See the [example documentation](example/README.md) for more information.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## Contributing

Feel free to contribute by opening issues and/or pull requests. Your feedback is very welcome!

## License

MIT License

Copyright (c) [2019] [Joran Dob]
