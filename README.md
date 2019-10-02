# subtitle_wrapper_package

[![](https://img.shields.io/badge/pub-v0.0.5-brightgreen.svg)](https://pub.dev/packages/subtitle_wrapper_package)


Subtitle Wrapper Plugin.

## Features
* Displaying of vtt subtitles 
* Loading of vtt subtitles from network
* Subtitle styling 

## Installation

This widget wraps the video player and displays the vtt subtitles on top. 

```dart
@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
          elevation: 2.0,
          child: SubTitleWrapper(
              videoPlayerController: videoPlayerController,
              subtitleController: SubtitleController(
                subtitleUrl: subtitleUrl,
                showSubtitles: true,
              ),
              subtitleStyle:
                  SubtitleStyle(textColor: Colors.white, hasBorder: true),
              videoChild: Chewie(
                controller: chewieController,
              ))),
    );
  }

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
