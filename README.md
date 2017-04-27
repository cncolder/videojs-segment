videojs-segment
===============

[![Greenkeeper badge](https://badges.greenkeeper.io/cncolder/videojs-segment.svg)](https://greenkeeper.io/)

Introduction
------------
A video.js plugin that play segment videos, not playlist. Progressbar show the right current time, buffered percent and total duration.

Getting started
---------------
See the `example.html` file.
Jump around `0:46`.

Install first:

```html
    <script src="/path/to/videojs.segment.js"></script>
```

Active it:

```javascript
    var player = videojs("example_video_1", {
        plugins: {
            segment: {}
        }
    });
```

Feed segment source:

```javascript
    player.src([{
      src: 'http://video-js.zencoder.com/oceans-clip.mp4',
      seconds: 46
    }, {
      src: 'http://video-js.zencoder.com/big_buck_bunny.mp4',
      seconds: 596
    }]);
```

Every source must have `src` and `seconds` property at least. Plugin will compute the time and adjust player UI.

That's all there is to it!

TODO
----
Best way to adjust UI update without overwrite videojs prototype.
Handle source type argument. `{type: 'video/mp4'}`
Avoid videojs error log when seek across segment gap.

Background
----------
Safari can play m3u8 file, which is a playlist file contain serial segment videos. Many people research how to do that on Desktop Chrome. But Google dont think so. Chrome on android support m3u8. Chrome on Google TV support m3u8. Only Chrome on desktop dont support it.

After many time searching I found MediaSource API and MPEG-Dash. There is a html5 player named `dosh.js` can parse mpd file(like m3u8). Fetch video data then feed to MediaSource. But wait! How to fetch data? The answer is `XMLHttpRequest`. There is no way to fetch public video on the other site.

So now. The only way to play segment videos is do it yourself.
