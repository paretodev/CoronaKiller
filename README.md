# 코로나 킬러

여러 웹사이트 링크로 분산되어 있던 코로나 관련 기능들을 하나의 모바일 앱으로 모은 프로젝트.

<br>

## 기술 스택

<br>

**SwiftUI**<br>

**MVVM**
<br>
<br>

- MVC, UIKit와 달리, View Model이 가지고 있는 @State, @Binding, @Observable object 데이터를 통해서, 객체가 서로 영향을 끼칠 수 있다.
- MVC에서는 1). delegate패턴, 2). target, action 패턴 3). 콜백(컴플리션 핸들러) 패턴 4). NotificationCenter - Observer 패턴을 통해서 한 객체의 변화가 다른 객체에 영향을 끼칠 수 있었다.

- 서로 다른 뷰 간의 의존성 주입, 객체간 메세지 주고 받기 등이, 바인딩 변수( state, binding observable object )를 주고 받는 것을 통해 간소화 되었다.

- 로직이 복잡해지는 것에 비해, 코드 복잡도나 가독성이 적게 복잡해지는 장점이 있다.
