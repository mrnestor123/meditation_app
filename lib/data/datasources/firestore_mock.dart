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
      "level":{
        "levelxp": 100,
        "level": 1,
        "xpgoal": 1000
      },
      "stagenumber": 1
    },
    "2": {
      "coduser": "xzv",
      "password": "malacara",
      "nombre": "Ernest Barrachina",
      "mail": "rostersmusic@gmail.com",
      "usuario": "ernestin",
      "level":{
        "levelxp": 300,
        "level": 2,
        "xpgoal":1100
      },
      "stagenumber": 1
    }
  },
  "userdata":{
    "xyv": {
      "readlessons" : {
        "1":{
            "codlesson": "10",
            "title": "The myth of multi-tasking",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
        "2":{
            "codlesson": "10",
            "title": "The myth of multi-tasking",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
         },
         "3":{
            "codlesson": "8",
            "title": "Functions of attention and peripheral awareness",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          }
      },
      "meditations": {
        "1":{
                "codmed": "acr",
                "duration":"15:00"
            },
        "2":{
                "codmed": "ahsr",
                "title": "Loving-kindness",
                "recording":"loving.mp3",
                "duration" : "20:00"
              },
          "3":{
                "codmed": "ahssr",
                "title": "The five hindrances",
                "recording": "hindrances.mp3",
                "duration" : "5:00"
          }
      }
    }
  },
  "lessons":{
    "1":{
        "brain": {
          "1":{
            "codlesson": "10",
            "title": "The myth of multi-tasking",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "2":{
            "codlesson": "9",
            "title": "Directing and sustaining attention",
            "group":"Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "3":{
            "codlesson": "8",
            "title": "Functions of attention and peripheral awareness",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "4":{
            "codlesson": "7",
            "title": "Conscious experience",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "5":{
            "codlesson": "6",
            "title": "The five hindrances",
            "group" : "Additional",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "6":{
            "codlesson": "5",
            "title": "Achieving stable attention",
            "group" : "Mindfulness" ,
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "7":{
            "codlesson": "4",
            "title": "Increasing mindfulness power",
            "group": "Mindfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "8":{
            "codlesson": "2",
            "title": "Mindfulness, what it is",
            "slider" : "new_slider.jpg",
            "group": "Mindfulness",
            "description": "Gives a general understanding of what mindfulness is",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "9":{
            "codlesson": "3",
            "title": "Benefits of mindfulness",
            "group":"Mindfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "10":{
            "codlesson": "1",
            "title": "Attention vs peripheral awareness",
            "slider" : "images/peripheral.png",
            "group": "Attention",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "11": {
            "codlesson": "0",
            "title": "Scope of attention",
            "slider" : "images/peripheral.png",
            "group": "Attention",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text": "Once you can direct and sustain the attention, you will work on controlling the scope of attention: how wide or narrow you want your focus to be. Many tasks on our daily life require to expand or contract our focus. When threading a needle or hearing someone in a noisy room. When watching football, our attention might expand to all the action on the field. Although we do have some control, without training our scope tends to change automatically. \n \n An expanded scope can include more things in attention. It can be useful for multitasking. Yet, when we’re trying to have stable attention a scope that keeps expanding will let in distractions. Determining the scope will be cultivated in stage six.",
            "stagenumber":1
          }  
        },
        "meditation": {
          "1":{
            "codlesson": "10",
            "title": "The myth of multi-tasking",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "2":{
            "codlesson": "9",
            "title": "Directing and sustaining attention",
            "group":"Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "3":{
            "codlesson": "8",
            "title": "Functions of attention and peripheral awareness",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "4":{
            "codlesson": "7",
            "title": "Conscious experience",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "5":{
            "codlesson": "6",
            "title": "The five hindrances",
            "group" : "Additional",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "6":{
            "codlesson": "5",
            "title": "Achieving stable attention",
            "group" : "Mindfulness" ,
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "7":{
            "codlesson": "4",
            "title": "Increasing mindfulness power",
            "group": "Minfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "8":{
            "codlesson": "2",
            "title": "Mindfulness, what it is",
            "slider" : "new_slider.jpg",
            "group": "Mindfulness",
            "description": "Gives a general understanding of what mindfulness is",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "9":{
            "codlesson": "3",
            "title": "Benefits of mindfulness",
            "group":"Mindfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "10":{
            "codlesson": "1",
            "title": "Attention vs peripheral awareness",
            "slider" : "images/peripheral.png",
            "group": "Attention",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          }
        }
      },
    "2":{
        "brain": {
          "1":{
            "codlesson": "10",
            "title": "The myth of multi-tasking",
            "group": "Mind",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "2":{
            "codlesson": "9",
            "title": "Directing and sustaining attention",
            "group":"Mind",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "3":{
            "codlesson": "8",
            "title": "Functions of attention and peripheral awareness",
            "group": "Mind",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "4":{
            "codlesson": "7",
            "title": "Conscious experience",
            "group": "Mind",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "5":{
            "codlesson": "6",
            "title": "The five hindrances",
            "group" : "Mind",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "6":{
            "codlesson": "5",
            "title": "Achieving stable attention",
            "group" : "Functions" ,
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "7":{
            "codlesson": "4",
            "title": "Increasing mindfulness power",
            "group": "Functions",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "8":{
            "codlesson": "2",
            "title": "Mindfulness, what it is",
            "slider" : "new_slider.jpg",
            "group": "Functions",
            "description": "Gives a general understanding of what mindfulness is",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "9":{
            "codlesson": "3",
            "title": "Benefits of mindfulness",
            "group":"Functions",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "10":{
            "codlesson": "1",
            "title": "Attention vs peripheral awareness",
            "slider" : "images/peripheral.png",
            "group": "Functions",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          }
        }, 
        "meditation": {
          "1":{
            "codlesson": "10",
            "title": "The myth of multi-tasking",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "2":{
            "codlesson": "9",
            "title": "Directing and sustaining attention",
            "group":"Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "3":{
            "codlesson": "8",
            "title": "Functions of attention and peripheral awareness",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "4":{
            "codlesson": "7",
            "title": "Conscious experience",
            "group": "Attention",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "5":{
            "codlesson": "6",
            "title": "The five hindrances",
            "group" : "Additional",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "6":{
            "codlesson": "5",
            "title": "Achieving stable attention",
            "group" : "Mindfulness" ,
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
           "7":{
            "codlesson": "4",
            "title": "Increasing mindfulness power",
            "group": "Minfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "8":{
            "codlesson": "2",
            "title": "Mindfulness, what it is",
            "slider" : "new_slider.jpg",
            "group": "Mindfulness",
            "description": "Gives a general understanding of what mindfulness is",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "9":{
            "codlesson": "3",
            "title": "Benefits of mindfulness",
            "group":"Mindfulness",
            "slider" : "new_slider.jpg",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          },
          "10":{
            "codlesson": "1",
            "title": "Attention vs peripheral awareness",
            "slider" : "images/peripheral.png",
            "group": "Attention",
            "description": "This lesson talks about the differences between attention and peripheral awareness",
            "text":"Peripheral awareness is x. Attention is y",
            "stagenumber":1
          }
        } 
      }
  }
}
""";

  DatabaseString();
  String getString() => db;
}
