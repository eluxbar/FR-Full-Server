$(() => {

    var MusicVideoIndex = 0;
    var MusicVideos = [
        {
            MusicAuthor: 'Lil Baby',
            MusicLabel: 'California Breeze',
            MP4Location: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155805199408046100/y2mate.is_-_Lil_Baby_California_Breeze_Official_Video_-WyhU6Zb_fhY-1080pp-1695635406.mp4',
            IconLocation: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155808163317166090/ab67616d0000b27366b04b41fa6f8908dce86695.jpg'
        },
        {
            MusicAuthor: '6IX9INE',
            MusicLabel: 'Billy',
            MP4Location: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155807702702882847/YT2mp3.info_-_6IX9INE__Billy__WSHH_Exclusive_-_Official_Music_Video.mp4',
            IconLocation: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155808406825877584/ab67616d0000b27314d3a2a7a92b85a06c93e544.png'
        },
        {   
            MusicAuthor: 'Loski',
            MusicLabel: 'Allegedly',
            MP4Location: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155808001014386728/YT2mp3.info_-_Loski_-_Allegedly_Official_Video.mp4',
            IconLocation: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155808528854958163/ab67616d0000b27301075ace56e7dff6d13cd828.png'
        },
        {
            MusicAuthor: 'DigDat',
            MusicLabel: 'No Gimmicks',
            MP4Location: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155807187906609153/YT2mp3.info_-_DigDat_-_No_Gimmicks_Official_Video.mp4',
            IconLocation: 'https://cdn.discordapp.com/attachments/1111316733937066055/1155808294808592424/ab67616d0000b273c364844fc1613a3b70ea1ece.jpg'
        }
    ];

    var RandomizeArray = (array) => {

        let currentIndex = array.length, randomIndex;
    
        while (currentIndex != 0) {
    
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex--;
    
            [array[currentIndex], array[randomIndex]] = [
                array[randomIndex],
                array[currentIndex]
            ];
            
        };
    
        return array;

    }

    var Slider = document.getElementById('loading_bar');

    Slider.addEventListener('input', (event) => {
        
        let Video = document.getElementById('video');

        Video.currentTime = event.target.value;

    });

    var PlayVideo = (VideoIndex) => {

        var VideoData = MusicVideos[VideoIndex - 1];
        
        $('#loading_toggle').html(`<i class="fa-solid fa-pause"></i>`);

        document.getElementById('loading_video').innerHTML = `

            <video src="${VideoData.MP4Location}" id="video"></video>
                
        `;

        document.getElementById('loading_image').src = VideoData.IconLocation;

        $('#loading_label').text(VideoData.MusicLabel);
        $('#loading_author').text(VideoData.MusicAuthor);

        let Video = document.getElementById('video');

        Video.volume = 0.375;
        Video.play();

        Video.addEventListener('loadedmetadata', function() {

            $('#loading_total').text(new Date(Video.duration * 1000).toISOString().substring(15, 19));
            $('#loading_bar').attr('max', Video.duration);

        });

        Video.addEventListener('timeupdate', () => {
            
            $('#loading_current').text(new Date(Video.currentTime * 1000).toISOString().substring(15, 19));

            if (Video.duration != null && Video.currentTime != null) {

                document.getElementById('loading_bar').value = Video.currentTime;

            };
        
        });

    };

    Back = () => {

        MusicVideoIndex -= 1;

        if (MusicVideoIndex <= 0) {
    
            MusicVideoIndex = MusicVideos.length;

        };

        PlayVideo(MusicVideoIndex);

    };

    Toggle = () => {

        let Video = document.getElementById('video');

        if ($('#video').get(0).paused) {

            Video.play();

            $('#loading_toggle').html(`<i class="fa-solid fa-pause"></i>`);

        } else {

            Video.pause();
            
            $('#loading_toggle').html(`<i class="fa-solid fa-play"></i>`);

        };

    };

    Forward = () => {

        MusicVideoIndex += 1;

        if (MusicVideoIndex > MusicVideos.length) {
    
            MusicVideoIndex = 1;

        };

        PlayVideo(MusicVideoIndex);

    };

    MusicVideos = RandomizeArray(MusicVideos);

    MusicVideoIndex = 1;

    PlayVideo(MusicVideoIndex);

});