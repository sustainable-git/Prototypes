# FoodApp

- 기간 : 3일
- 설명 : 오늘의 메뉴 추천!

<br>

## Demo

<div align=center>
<img width=480 src="./imageFiles/01.gif"> <img width=480 src="./imageFiles/02.gif">
</div>
    
<br>

## 특징
- MVVM - C, iOS Clean Architecture
- No Storyboard
- Xib
- Compositional Layout
- Dependency injection
- Unit Test
- UI Test

<br>

## Architecture

![](https://i.imgur.com/k1Jpfyb.png)

<br>

## View

![](https://i.imgur.com/175jPFF.png)

<br>

## 자세한 내용

- MVVM -C, iOS Clean Architecture
    - Testable, Scalable, maintainable한 code를 만들기 위해 해당 Architecture를 적용하였습니다.
    - ViewModel이 UIKit에 independent하도록 만들어 test가 가능하도록 하였습니다.
    - 상위 module을 알지 못하도록 protocol을 통한 참조를 하여 결합도를 낮추어 수정에는 닫혀있고 확장에는 열려있도록 하였습니다.
    - Repository pattern을 이용하여 Local Data가 아닌 Server Data를 사용하도록 Business Logic이 변경되어도 Repository 이하만 변경하면 되도록 유지 보수에 드는 소요를 줄이고자 하였습니다.
    - 또한 Coordinator Pattern을 이용해 View가 화면 전환에 대한 책임이 없도록 하고, 의존성 주입을 Coordinator에서 할 수 있도록 하였습니다.

- No Storyboard
    - Coordinator pattern을 이용할 생각이었기 때문에 Storyboard가 없습니다.
    - SceneDelegate에서 AppCoordinator를 만들고, AppCoordinator가 하위 Coordinator를 만듭니다.
    - 이후 하위 Coordinator가 ViewController를 만들고, 첫 ViewController가 NavigationController에 push됩니다.
    - 상위 Layer에서 모든 작업이 끝나고 NavigationController를 보여주면 첫 화면이 등장하게 됩니다.

- Xib
    - View와 ViewController는 XML을 이용해 View를 초기화할 수 있습니다.
    - 이렇게 한 이유는 모든 View를 code로 짜는 것보다 효율적이기 때문입니다.
    - code로 짜면 View Layout Logic이 상당히 길어지고, View의 모양을 한눈에 확인할 수 없습니다.
    - 때문에 모든 View와 ViewController를 Xib을 이용해 만들고, AutoLayout을 Xib에 적용해 두었습니다.

- Compositional Layout
    - UICollectionViewCompositionalLayout은 iOS13.0+에서 지원하는 기능입니다.
    - Compositional Layout을 사용했을 때 paging을 하기 위해 불필요한 customizing을 할 필요가 없기 때문에 이를 사용하였습니다.

- Dependency Injection
    - 모듈 간 결합도를 느슨하게 하기 위하여 의존성을 주입하였습니다.
    - 의존성 주입에는 3가지 방법이 있습니다.
        1. Constructor Injection
        2. Property Injection
        3. Method Injection
    - 1번 방법인 Constructor Injection은 Compile level에서 의존성을 확인할 수 있기 때문에 유리하지만, nibName을 이용해 ViewController를 만들기 위해 하여 1번 방법을 사용하지 않았습니다.
    - 3번 방법인 Method Injection은 Coordinator가 ViewController를 바라보았을 때 init()이라는 internal한 method가 하나 더 생기기 때문에 사용하지 않았습니다.
    - 결과적으로 2번 방법인 Property Injection 방법을 이용했고, Coordinator에서 ViewController를 만든 이후에 즉시 ViewModel을 주입해 주는 방식으로 의존성을 주입했습니다.

- Unit Test
    - 첫 화면의 ViewModel과 UseCase에 대한 Unit Test를 적용했습니다.
    - Mock Repository를 이용하여 Entity를 받고, View에 보내기 위한 method에서 올바른 출력을 보내는지 확인하였습니다.

- UI Test
    - 첫 화면과 두 번째 화면에 대한 UITest를 적용했습니다. 내용은 다음과 같습니다.
        1. 첫 화면에서 swipe를 5번 할  수 있는가? (cell이 6개이기 때문에 swipe는 5번 가능)
        2. swipe를 5번 한 이후 반대 방향으로 다시 5번 할 수 있는가?
        3. reset button이 잘 동작하는가?
        4. reset button을 누르면 첫 번째 cell로 돌아가서 다시 5번 swipe 할 수 있는가?
        5. 첫 번째 cell을 선택한 후 back button을 touch해 돌아올 수 있는가?
        6. swipe를 2회 한 후 cell을 선택하고, back button을 touch해 다시  3번 swipe가 가능한가?
