# Examples You Can Try

### This is, after all, a _Swift_ event.

*Request*
```
{
    "image-url": "https://media.wmagazine.com/photos/5853f7a9d3b7a5db18f3d81f/4:3/w_1536/swift-gigi-bfa.jpg"
}
```

*Response*
```
{
  "results": [
    {
      "isCelebrity": true,
      "name": "Taylor Swift"
    }
  ]
}
```

### This seemed fitting since Swift is _Apple_ technology.

*Request*
```
{
    "image-url": "http://cbsnews1.cbsistatic.com/hub/i/2011/10/06/957adcbf-a644-11e2-a3f0-029118418759/frontstevejobs_1.jpg"
}
```

*Response*
```
{
  "results": [
    {
      "isCelebrity": true,
      "name": "Steve Jobs"
    }
  ]
}
```

### Unfortunately, I'm not a celebrity. ;)

*Request*
```
{
    "image-url": "http://mtjc.fm/wp-content/uploads/2014/10/Jaime-blue-steel.png"
}
```

*Response*
```
{
  "celebrityResults": [
    {
      "isCelebrity": false,
      "name": "Unknown"
    }
  ]
}
```

### An example of a group (cast of Star Trek: The Next Generation)

*Request*
```
{
    "image-url": "http://tng.trekcore.com/gallery/albums/publicity/season5/cast_s5.jpg"
}
```

*Response*
```
{
    "celebrityResults": [
      {
        "isCelebrity": true,
        "name": "Jonathan Frakes"
      },
      {
        "isCelebrity": false,
        "name": "Unknown"
      },
      {
        "isCelebrity": true,
        "name": "Patrick Stewart"
      },
      {
        "isCelebrity": true,
        "name": "Brent Spiner"
      },
      {
        "isCelebrity": false,
        "name": "Unknown"
      },
      {
        "isCelebrity": true,
        "name": "Marina Sirtis"
      },
      {
        "isCelebrity": true,
        "name": "Whoopi Goldberg"
      },
      {
        "isCelebrity": false,
        "name": "Unknown"
      }
    ]
}
```
