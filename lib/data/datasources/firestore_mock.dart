class DatabaseString {
  String db = r"""
{
  "users": {
    "1": {
      "coduser": "xyv",
      "password": "ernesto",
      "nombre": "Ernest Barrachina",
      "mail": "ernestbarra97@gmail.com",
      "usuario": "ernestino",
      "stagenumber": 1
    },
    "2": {
      "coduser": "xzv",
      "password": "malacara",
      "nombre": "Ernest Barrachina",
      "mail": "rostersmusic@gmail.com",
      "usuario": "ernestin",
      "stagenumber": 1
    }
  },
  "userlists": {
    "1": {
      "coduser":"xyv",
      "remaininglessons":{
            "1":{
              "codlesson": 1,
              "title": "Peripheral awareness vs attention",
              "slider" : "new_slider.jpg",
              "description": "This lesson talks about the differences between attention and peripheral awareness",
              "text":"Peripheral awareness is x. Attention is y",
              "stagenumber": 1
              },
            "2":{
              "codlesson": 2,
              "title": "The five hindrances",
              "slider" : "new_slider.jpg",
              "description": "This lesson talks about the differences between attention and peripheral awareness",
              "text":"Peripheral awareness is x. Attention is y",
              "stagenumber": 1
              }
          },
        "readlessons" : {
            "1":{
              "codlesson":1,
              "title":"Test lesson",
              "slider": "test_slider.jpg",
              "description" :"This lesson is a test",
              "text": "you can lick my anus",
              "stagenumber":1
              }
            } ,
          "meditations": {
              "1":{
                "codmed": "acr",
                "duration":"15"
              },
              "2":{
                "codmed": "ahsr",
                "title": "Loving-kindness",
                "recording":"loving.mp3",
                "duration" : "20"
              },
              "3":{
                "codmed": "ahssr",
                "title": "The five hindrances",
                "recording": "hindrances.mp3",
                "duration" : "5"
          }
        }
      }
  },
  "guidedmeditations":{
    "1":{
      "codmed":"ahssr",
      "title" : "How to be patient",
      "duration":15
    },
    "2":{
      "codmed":"ashr",
      "title": "Peripheral awareness vs attention",
      "duration" : 10
    }
  },
  "lessons":{
    "1":{
        "brain": {
          "1":{
            "codlesson": 1,
            "title": "Attention vs peripheral awareness",
            "slider" : "new_slider.jpg",
            "group": "Attention",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "2":{
            "codlesson": 2,
            "title": "Mindfulness, what it is",
            "slider" : "new_slider.jpg",
            "group": "Mindfulness",
            "description": "Gives a general understanding of what mindfulness is",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "3":{
            "codlesson": 3,
            "title": "Benefits of mindfulness",
            "group":"Mindfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "4":{
            "codlesson": 4,
            "title": "Increasing mindfulness power",
            "group": "Minfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "5":{
            "codlesson": 5,
            "title": "Achieving stable attention",
            "group" : "Mindfulness" ,
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "6":{
            "codlesson": 6,
            "title": "The five hindrances",
            "group" : "Additional",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "7":{
            "codlesson": 7,
            "title": "Conscious experience",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "8":{
            "codlesson": 8,
            "title": "Functions of attention and peripheral awareness",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "9":{
            "codlesson": 9,
            "title": "Directing and sustaining attention",
            "group":"Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "10":{
            "codlesson": 10,
            "title": "The myth of multi-tasking",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          }
        }
      },
    "2":{
      "codlesson": "2",
        "title": "The five hindrances",
        "slider" : "new_slider.jpg",
        "description": "This lesson talks about the differences between attention and peripheral awareness",
        "text":"Peripheral awareness is x. Attention is y",
        "stagenumber": 1
    },
    "3":{
      "codlesson": "3",
        "title": "Why start meditating",
        "slider" : "new_slider.jpg",
        "description": "This lesson talks about the differences between attention and peripheral awareness",
        "text":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
        "stagenumber": 1
    },
    "4":{
      "codlesson": "4",
      "title": "How to be a good meditator ",
      "slider" : "new_slider.jpg",
      "description": "This lesson talks about the differences between attention and peripheral awareness",
      "text":"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
      "stagenumber": 1
    } 
  }
}
""";

  DatabaseString();
  String getString() => db;
}
