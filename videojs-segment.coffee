segmentPlugin = (options) ->
    Player = @constructor
    Player.__super__ =
        src: Player::src
        currentTime: Player::currentTime
        duration: Player::duration
        bufferedPercent: Player::bufferedPercent
    index = start = end = duration = 0
    segments = []

    ###
    The source function updates the video source

    **Array of Source Segment Objects:** To provide multiple source segments so
    that it can be played like a single file.

        myPlayer.src([
          { seconds: 300, src: "http://www.example.com/path/to/video1.mp4" },
          { seconds: 100, src: "http://www.example.com/path/to/video2.mp4" },
          { seconds: 400, src: "http://www.example.com/path/to/video3.mp4" }
        ]);
    ###
    Player::src = (source) ->
        if source instanceof Array and source[0]?.seconds
            segments = source
        
            # Get or set the current time (in seconds) with start time when segment source.
            Player::currentTime = (seconds) ->
                if seconds
                    # TODO: How to avoid InvalidStateError log when switch src? if @isReady_
                    super seconds - start

                    @segmentSeek seconds
                else
                    super + start

            # Get the length in time of the videos in seconds
            Player::duration = (seconds) ->
                seconds = duration if seconds
                super seconds
        
            # Get the percent (as a decimal) of the videos that's been downloaded.
            Player::bufferedPercent = ->
                super + start / duration
        
            # Seek to.
            Player::segmentSeek = (seconds) ->
                return if seconds < 0 or seconds > duration or seconds > start and seconds < end
    
                index = start = 0
                while seconds >= start + segments[index].seconds
                    start += segments[index].seconds
                    index++
                end = start + segments[index].seconds
            
                @src segments[index].src
                @one 'canplay', -> @currentTime seconds if @currentTime() isnt seconds
                @play()
                
            duration = 0
            duration += seg.seconds for seg in segments
            end = start + segments[index].seconds

            @on 'ended', ->
                if index < segments.length - 1
                    start = end
                    index++
                    end += segments[index].seconds
                    @src segments[index].src
                    @play()
                
            # TODO: I wanna return source[0]. Let videojs read {type: 'video/mp4' ...} style data. But it will down to the dies loop.
            super source[0].src
        
        else
            super


window.videojs.plugin 'segment', segmentPlugin
