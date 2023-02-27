.column {
  float: left;
  width: 33.33%;
  padding: 5px;
}

.row::after {
  content: "";
  clear: both;
  display: table;
}

<img src="https://i.imgur.com/lNV2KBm.png" width="150" height="150" style="inset(0% 45% 0% 45% round 10px)"/>

# night right

night right is a simple sleep analysis and snore reduction app for iOS. Using a custom trained AI model, night right listens while you sleep and gently wakes you up when it detects snoring. Over time night right helps train your body to reduce snoring.



## Features

- Modern and functional UI built on SwiftUI
- Records clips of audio events such as snoring and sleep talking overnight
- Tracks snoring progress over time
- Snoring alarm and wake up alarm


## To Do List

- Implement bedtime and wakeup notifications
- Implement Apple Watch support to silenty wake up the user via vibrations when snoring is detected
- Implement cloud data syncing with my custom <a href="https://github.com/nickrcole/authbackend">authentication backend</a>


## Demo
<div class="row">
  <div class="column">
    <img src="https://github.com/nickrcole/nightright/blob/main/demo%20assets/welcome.gif?raw=true" height="500"/>
  </div>
  <div class="column">
    <img src="img_forest.jpg" alt="Forest" style="width:100%">
  </div>
  <div class="column">
    <img src="img_mountains.jpg" alt="Mountains" style="width:100%">
  </div>
</div>


## Credits

Developer - Nicholas Cole\
App Art - Jaime Yaukey\
Some icons proivded by icons8

