# Flutter 로 웹툰 앱 만들기


Nomad coder를 보면서 복습하면서 만들어 본 오늘의 웹툰 리스트

강의에서 제공한 노마드코더에서 제공한 네이버웹툰 API 이외 [korea-webtoon-api](https://github.com/HyeokjaeLee/korea-webtoon-api)에서 가져온 카카오웹툰, 카카오페이지 웹툰 API를 추가했습니다.


## 코드컨벤션
|컨벤션이름|설명|
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


> Gitmoji를 써볼까 싶은데 과연 잘 써질지 모르겟다.


---

### Refactoring 
[2023/05/18]

1. fontStyle 공통코드 추가  

    fontFamily를 추가해서 fontStyle이 길어지는 것 같아서 공통코드로 fontStyle이 추가했는데 생각보다 text를 사용하는 위젯이 별로 없고, 따로 속성을 추가하는 경우도 많아서 공통코드로 묶기가 애매했다.
    디자인 없이 임의로 보일때마다 추가한 fontStyle이 많아서 이것도 묶을 수 없었다. 추가할수록 오히려 더 지저분해지는 느낌이였다.
    해당 앱은 text를 별로 사용하지 않고 widget, class가 적어서 큰 도움은 되지않았고, 항상 공통코드로 묶을 때는 이미 많이 사용한 상태에서 공통코드로 묶어서 이전에 사용했던 코드를 다시 리팩토링을 많이 했는데, 자주 사용할 것같은 코드는 미리 묶어서 공통코드로 만드는 연습을 하고싶다.

2. 클릭 공간 넓히기

    - main -> list로 넘어가는 버튼의 공간이 작아서 해당 버튼 영역을 text를 클릭해도 넘어갈수있게 변경

    - list -> detail로 넘어가는 영역을 GestureDetector로 onTap 속성을 줬는데, 빈영역을(이미지나 txt가 없는 곳) 클릭하면 클릭이 안됨. InkWell로 수정하니까 됨
    [Flutter 공식문서(GestureDetector)](https://docs.flutter.dev/ui/advanced/gestures)를 보면 GestureDetector는 모든 유형의 사용자 상호작용을 추적하는데 이 위젯은 따지고보면 버튼이 아니기 때문에 빈 영역을 누른다고 onTap이 되지않는 걸까라고 추측 중