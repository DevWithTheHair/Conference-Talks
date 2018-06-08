# Examples You Can Try

### This is, after all, a _Swift_ example.

*Request*
```
{
    "image-url": "https://media.wmagazine.com/photos/5853f7a9d3b7a5db18f3d81f/4:3/w_1536/swift-gigi-bfa.jpg"
}
```

*Response*
```
{
  "faceResults": [
    {
      "age": {
        "confidence": 0.89057744,
        "maxAge": 23,
        "minAge": 20
      },
      "gender": {
        "confidence": 0.9999995,
        "gender": "FEMALE"
      }
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
  "faceResults": [
    {
      "age": {
        "confidence": 0.97768694,
        "maxAge": 58,
        "minAge": 55
      },
      "gender": {
        "confidence": 0.99999607,
        "gender": "MALE"
      }
    }
  ]
}
```

### I've always looked _younger_ than my actual age. 😉

*Request*
```
{
    "image-url": "http://mtjc.fm/wp-content/uploads/2014/10/Jaime-blue-steel.png"
}
```

*Response*
```
{
  "faceResults": [
    {
      "age": {
        "confidence": 0.5370779,
        "maxAge": 26,
        "minAge": 21
      },
      "gender": {
        "confidence": 0.99952614,
        "gender": "MALE"
      }
    }
  ]
}
```

### An example of a more challenging determination. Tig Notaro's "Happy To Be Here" stand-up special covers this very topic.

*Request*
```
{
    "image-url": "https://womenandhollywood.com/wp-content/uploads/2018/04/1Y8ZDPAgFIphVVQ1y0BFXiw-1024x576.jpeg"
}
```

*Response*
```
{
  "faceResults": [
    {
      "age": {
        "confidence": 0.63663036,
        "maxAge": 51,
        "minAge": 47
      },
      "gender": {
        "confidence": 0.7811648,
        "gender": "MALE"
      }
    }
  ]
}
```
