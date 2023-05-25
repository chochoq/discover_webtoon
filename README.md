# Flutter 로 웹툰 앱 만들기


Nomad coder를 보면서 복습하면서 만들어 본 오늘의 웹툰 리스트

강의에서 제공한 노마드코더에서 제공한 네이버웹툰 API 이외 [korea-webtoon-api](https://github.com/HyeokjaeLee/korea-webtoon-api)에 제공된 카카오웹툰, 카카오페이지 웹툰 API를 추가했습니다.


<img src='https://velog.velcdn.com/images/chocho/post/2413e016-ecb0-4cfb-907a-3610a5125121/image.gif' width='80%'>


<!-- # 추가로 넣은 기능
1. 날짜
2. 로고 
3. 새로운 API
4. 리스트 widget -->

<!-- # 강의에서 배운 것
# 추가로 기능 넣으면서 배운 것  -->

---
## git comment convention
|name|description|
|--|--|
|Add|코드 추가|
|Edit|코드 수정|
|Fix|버그를 고친 경우|
|Design|CSS 등 사용자 UI 디자인 변경|
|Style|코드 포맷 변경, 세미 콜론 누락, 코드 수정이 없는 경우|
|Refactor|프로덕션 코드 리팩토링|
|Comment|필요한 주석 추가 및 변경|
|Docs|문서를 수정한 경우|
|Chore|빌드 테스트 업데이트, 패키지 매니저를 설정하는 경우(프로덕션 코드 변경 X)|
|Rename|파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우|
|Remove|파일을 삭제하는 작업만 수행한 경우|



---

# Dependencies

- http
- url_launcher
- shared_preferences
- timer_builder
- intl



---
## 추가한 기능들

1. API 추가 사용

- [korea-webtoon-api](https://github.com/HyeokjaeLee/korea-webtoon-api)이라는 API를 찾았다. naver 네이버 웹툰, kakao 카카오 웹툰, kakaoPage 카카오페이지에서 오늘 업데이트된 웹툰의 정보를 가져온다. 다양한 웹툰 정보를 가져오지만, 이미 가져왔던 nomadCoder에서 가져온 값들과는 달라서 아예 새로운 API로 다시 할까 고민하다가 2가지 정보값을 가지는 걸로 연습해보자 해서 네이버웹툰에서 가져오는 API는 노마드코더 / 카카오페이지와 카카오웹툰에서는 오픈 API를 이용했다.
[lib/services/api_service.dart](https://github.com/chochoq/discover_webtoon/blob/master/lib/services/api_service.dart)


2. AppBar


|<img src='https://velog.velcdn.com/images/chocho/post/5a1433f1-477c-4cef-bf33-f6f70c6633f3/image.png' width='80%'>| |
|--|--|
|<img src='https://velog.velcdn.com/images/chocho/post/27daf3c8-bc67-40ce-b439-608a0f26f806/image.jpg' width='50%'>|<img src='https://velog.velcdn.com/images/chocho/post/a070a715-1799-45df-bef6-5f4b096f9243/image.PNG' width='50%'>|



- 로고는 로고샵을 이용해서 만들었다. 로고 만드는 여러가지 사이트를 찾아다녔는데 원하는 대로 만들기가 생각보다 어려웠다. 디스커버리 웹툰을 축약해서 제목을 지었는데 글씨가 꽤 귀여웠다.


<img src='https://velog.velcdn.com/images/chocho/post/65f48f30-3fa8-4189-bf3b-31583f538f5f/image.png' width='50%'>


```

AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.asset("images/ditoonLogo.png", height: 55),
              ),
              Text(
                "$dayOfWeek에 업데이트 된 웹툰😍",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Pretendard',
                  height: 4,
                ),
              ),
            ],
          ),
          elevation: 0.0,
        ),
```

```
    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat('EEEE', 'ko_KR').format(now);
```

- AppBar안에 넣어주었는데, AppBar 위에 로고만 들어가 있는게 심심해 보여서 오늘의 요일을 추가해주었다. DateTime 함수를 사용했는데, 이 전에는 요일이나 오늘의 날짜같은 것은 쿼리를(mySQL now()) 이용해 사용해서 쓸 일이 없었는데 한글 포맷도 된다는 사실을 처음 배웠다.




### Refactoring 
[2023/05/18]

1. fontStyle 공통코드 추가  

<img src='https://velog.velcdn.com/images/chocho/post/8c0da3b7-4f51-4799-851e-312735deb0e3/image.png' width='50%'>


```import 'package:flutter/material.dart';

class TextStyles {
  static const f30W800TextStyle = TextStyle(
    fontSize: 30,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w800,
  );
  static const f15W800TextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    fontFamily: 'Pretendard',
  );
  static const f15TextStyle = TextStyle(
    fontSize: 15,
    fontFamily: 'Pretendard',
  );
} 
```
    
    
- fontFamily를 추가해서 fontStyle이 길어지는 것 같아서 공통코드로 fontStyle이 추가했는데 생각보다 text를 사용하는 위젯이 별로 없고, 따로 속성을 추가하는 경우도 많아서 공통코드로 묶기가 애매했다.
    디자인 없이 임의로 보일때마다 추가한 fontStyle이 많아서 이것도 묶을 수 없었다. 추가할수록 오히려 더 지저분해지는 느낌이였다.
    해당 앱은 text를 별로 사용하지 않고 widget, class가 적어서 큰 도움은 되지않았고, 항상 공통코드로 묶을 때는 이미 많이 사용한 상태에서 공통코드로 묶어서 이전에 사용했던 코드를 다시 리팩토링을 많이 했는데, 자주 사용할 것같은 코드는 미리 묶어서 공통코드로 만드는 연습을 하고싶다.

- 변수이름을 bigTextStyle 이런식으로 해야하나 싶었는데 공통으로 추가하지 않은 폰트스타일의 폰트나 weight도 제각각이라서 더 헷갈릴거 같아서 직관적으로 fontSize와 fontWeight의 크기를 이름으로 지정했다. 규칙을 정하거나 어느 위치에는 어떤 스타일의 폰트가 들어가있는지 정해져있다면 이런식으로 안써도될 것 같긴하지만 내가 보기에는 편한대로 우선 지정해보았다.

2. 클릭 공간 넓히기

<img src='https://velog.velcdn.com/images/chocho/post/c0e1ee25-b8c5-4d85-b8b8-4a481bc100aa/image.png' width='60%'>

- main -> list로 넘어가는 버튼의 공간이 작아서 해당 버튼 영역을 text를 클릭해도 넘어갈수있게 변경

<img src='https://velog.velcdn.com/images/chocho/post/5ed8836c-926f-4c00-a308-e12c930fffcd/image.png' width='60%'>

  - list -> detail로 넘어가는 영역을 GestureDetector로 onTap 속성을 줬는데, 빈영역을(이미지나 txt가 없는 곳) 클릭하면 클릭이 안됨. InkWell로 수정하니까 됨
  [Flutter 공식문서(GestureDetector)](https://docs.flutter.dev/ui/advanced/gestures)를 보면 GestureDetector는 모든 유형의 사용자 상호작용을 추적하는데 이 위젯은 따지고보면 버튼이 아니기 때문에 빈 영역을 누른다고 onTap이 되지않는 걸까라고 추측 중
  +) GestureDetector에서 ```behavior: HitTestBehavior.translucent``` 혹은 ```behavior: HitTestBehavior.opaque```속성을 사용하면 터치범위를 늘릴 수 있다고 한다.
  InkWell과 GestureDetector 문서을 꼼꼼히 읽어봐야겟다.

[2023/05/19]

1. 클린코드 연습 -> Magic Number 사용 지양하기
    - '의미 있는 숫자는 array index 값이더라도 하드코딩 하지않기'라고 해서, ListView안에 들어가는 itemCount 숫자를 변수안에 넣었다.
    (특정 인덱스 넘버가 왜 쓰였는지 이해하기 어려운 경우가 있기에 지양한다고 한다, 숫자말고도 String도 포함 하드코딩을 하는 부분은 꼭 다시 확인해야한다.)
    - 사이즈 박스의 size도 반복되는 게 있어서 위젯으로 추가해보았다.

    [참고) 인프런 - 클린코드찍먹](https://www.inflearn.com/course/%ED%81%B4%EB%A6%B0%EC%BD%94%EB%93%9C-%EC%B0%8D%EB%A8%B9/dashboard)


[2023/05/25]

1. 디버깅 && 리팩토링

변경전
```
    if (service == '네이버 웹툰') {
      webtoonApi = webtoonsNaver;
      serviceEng = 'naver';
    } else if (service == '카카페 웹툰') {
      webtoonApi = webtoonsKakaoPage;
      serviceEng = 'kakaoPage';
    } else {
      webtoonApi = webtoonsKakao;
      serviceEng = 'kakao';
    } 
```
  이런식으로 사용하고 있던 코드에서 '카카페 웹툰'을 '카카오페이지 웹툰'으로 변경함으로써 문제가 생긴 것을 뒤늦게 확인했다.
  비교하는 값을 변수로 넣어 주기로 합의. 비교하는 값을 바꾸고싶은데 쉽게 생각나지않는다. 

  변경후
```
  final String naverService = '네이버 웹툰';
  final String kakaoPageService = '카카오페이지 웹툰';
  final String kakaoService = '카카오 웹툰';


    if (service == naverService) {
      webtoonApi = webtoonsNaver;
      serviceEng = 'naver';
    } else if (service == kakaoPageService) {
      webtoonApi = webtoonsKakaoPage;
      serviceEng = 'kakaoPage';
    } else {
      webtoonApi = webtoonsKakao;
      serviceEng = 'kakao';
    }


```

2. 1과 같은 문제를 List로 다시 리팩토링
  하다보니까 initialize도 해줬어야 해서 성능적으로는 뭐가 맞는지는 잘 모르겟다.
  List로 하는게 다시 바꾸게 되도 바꾸거나 보기 편할 것 같아서 수정 했는데.
  ```
  final List<String> servicesNameKr = ['네이버 웹툰', '카카오페이지 웹툰', '카카오 웹툰'];
  final List<String> servicesNameEng = ['naver', 'kakaoPage', 'kakao'];
  ```


---

### 후기

간단하게 만든거지만 예뻐보이고 싶었는데, 머리속에서 떠오르는 대로 만들다보니까 정보값도 별로 없어보이고, 정말 허해보여서 슬펐다. 이것저것 레퍼런스를 찾아봤지만 생각보다 어려운 일이 였다. 다른 어플을 보면서 평가하는 것은 쉽지만 막상 내가 만드려고 하면 생각이 나지않는다. UIUX디자이너들 정말 존경스럽다. 시간이 되면 UX공부도 해보고싶다.

이렇게 리팩토링하면서 오랫만에 재미있는 감정을 느꼈다. flutter의 widget은 Lego같은 것이라고 widget을 설명할 때 자주 얘기 하는데 평소에는 아 그냥 그렇구나했는데, 이번에 이리저리 조립해가는게 정말 Lego같고 게임 같다는 느낌이 들어서 아주 즐거웠다. 
