<html>
<head>
    <link href="css/screen.css" rel="stylesheet" type="text/css">
    <script src="js/jquery-1.11.2.min.js"></script>
    <script src="js/vue.min.js"></script>
    <script src="js/moment.min.js"></script>
</head>
<body id="demo">

    <div id="clock-box">
        <div class="clock-text" style="font-family: 'Open Sans'; font-size: 125px; color: {{current.tokei.color}};top: {{current.tokei.top}}px; left: {{current.tokei.left}}px">
            <span>{{hour}}</span>
            <span style="visibility:{{colonVisibility}}">:</span>
            <span>{{minute}}</span>
        </div>
        <div class="info-wrapper">
            <div class="info-box">
                <div class="header">
                    <div class="header">
                        <strong class="name">{{current.name}}</strong>
                        <span class="title">{{current.title}}</span>
                    </div>
                    <div class="body">
                        <span class="bio">{{current.bio}}</strong>
                        <span class="taken_by">
                            <span>&mdash; Photo taken by</span>
                            <strong>{{current.taken_by}}</strong>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
<script src="js/clock.js"></script>
</html>