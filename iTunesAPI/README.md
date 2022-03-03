# iTunesAPI

- 기간 : 4일
- 설명 : [iTunesAPI](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/)를 이용해 AppStore 구현

<br>

## Demo

<img src="./imageFiles/Demo.gif">

<br>

## 특징

- MVVM-C, iOS Clean Architecture
- No Storyboard
- Xib
- Compositional Layout
- Dependency injection
- Custom Framework, wrapping
- Disk caching
- MD5 hash function
- URLSession cancel
- Debounce
- Localization
- Unit Test
- UI Test

<br>

## Architecture

<img src="https://i.imgur.com/VOB9gHo.jpg">

<br>

## View

<img src="https://i.imgur.com/TjDgBS7.jpg">

<br>

## 자세한 내용

- MVVM-C, iOS Clean Architecture

    - Testable, Scalable, maintainable한 code를 만들기 위해 해당 Architecture를 적용하였습니다.
    - ViewModel이 UIKit에 independent하도록 만들어 test가 가능하도록 하였습니다.
    - 상위 module을 알지 못하도록 protocol을 통한 참조를 하여 결합도를 낮추어 수정에는 닫혀있고 확장에는 열려있도록 하였습니다.
    - Repository pattern을 이용하여 Network로부터 Data를 추상화하여 UseCase로 전달합니다.
    - 또한 Coordinator Pattern을 이용해 View가 화면 전환에 대한 책임이 없도록 하고, 의존성 주입을 Coordinator에서 하였습니다.

- No Storyboard

    - 화면전환에 대한 책임이 Coordinator에 있기 때문에 Storyboard가 불필요하였습니다.
    - SceneDelegate에서 AppCoordinator를 만들고, AppCoordinator가 하위 Coordinator를 만듭니다.
    - 이후 하위 Coordinator가 ViewController를 만들고, 첫 ViewController가 NavigationController에 push됩니다.
    - 상위 Layer에서 모든 작업이 끝나고 NavigationController를 보여주면 첫 화면이 등장하게 됩니다.

- Xib

    - View와 ViewController는 XML을 이용해 View를 초기화할 수 있습니다.
    - Xib를 이용하면 모든 View를 code로 짜는 것보다 효율적입니다.
    - code로 짜면 View Layout Logic이 상당히 길어지고, View의 모양을 한눈에 확인할 수 없습니다.
    - 때문에 모든 View와 ViewController를 Xib을 이용해 만들고, AutoLayout을 Xib에 적용해 두었습니다.

- Compositional Layout

    - UICollectionViewCompositionalLayout은 iOS13.0+에서 지원하는 기능입니다.
    - Compositional Layout을 사용했을 때 paging을 하기 위해 불필요한 customizing을 할 필요가 없습니다.
    - 또한 Accessibility를 고려하여 size를 estimated로 적용했을 때 자동으로 cell의 크기가 변경되기 때문에 사용하였습니다.

- Dependency injection

    - 모듈 간 결합도를 느슨하게 하기 위하여 의존성을 주입하였습니다.
    - 의존성 주입에는 3가지 방법이 있습니다.
        - 1. Constructor Injection
        - 2. Property Injection
        - 3. Method Injection
    - 1번 방법인 Constructor Injection은 Compile level에서 Error를 확인할 수 있기에 사용하였습니다.
    
- Custom Framework, wrapping

    - iTunesAPI/NetworkManager.xcodeproj는 제가 직접 생성한 Network Framework 입니다.
    - 현업에서 Network를 도와주는 Framework가 존재할 수 있기 때문에 해당 역할을 하는 Framework를 만들어 보았습니다.
    - 또한 NetworkService라는 객체를 만들어 Framework를 Wrapping하여 Framework에 대한 결합을 최소화하였습니다.

- Disk caching

    - ImageFile은 비용이 큰 File이고, 이를 받기 위해서는 시간과 비용이 많이 발생합니다.
    - 이런 소모를 최소화하기 위해 ImageDownloadRepository에서 Image를 Disk에 caching하도록 하였습니다.

- MD5 hash function

    - Image 요청이 URLString형태로 올 때에 이를 caching key로 바로 사용할 수 없습니다.
    - URLString에는 ://가 포함되어 있기 때문에 제대로 cache할 수 없습니다
    - 때문에 MD5 hash function으로 caching key를 만들어 해결하였습니다.

- URLSession cancel

    - URLSession은 비동기 작업이고, Network가 느리거나 용량이 큰 file을 다운로드하려면 시간이 많이 필요합니다.
    - 이런 상황에서 CollectionView를 빠르게 scroll하면 cell이 reuse되면서 Image의 순서가 변경될 수 있습니다.
    - 그래서 prepareForReuse에서 URLSessionDownloadTask를 cancel하도록 만들었습니다.

- Debounce

    - 검색어를 Typing하는 과정에서 검색어의 자모의 개수만큼 updateSearchResults method가 불릴 수 있습니다.
    - 불필요한 Network요청을 하는 만큼 시간과 자원을 소모하므로, Debounce를 적용하여 이를 최소화하였습니다.
    - DispatchWorkItem을 유지하면서 일정 시간 이상 대기하여야지만 Search가 진행되도록 하였습니다.

- Localization

    - 현재 앱에는 korean과 english 다국어 처리가 되어 있습니다
    - 이는 다국어 앱을 의도하여서 만들었다기보다는, String에 대한 처리를 Wrapping하기 위한 의도가 컸습니다.

- Unit Test

    - Mock 객체를 만들어서 Repository로 올바른 응답이 오는 것을 가정하여 ViewModel에서 호출한 함수가 UseCase와 Repository를 따라 적절하게 반환되는지 확인하였습니다.
    - Main Scene에 대해서만 구현해 두었는데, Detail Scene의 경우 ViewModel이 생성될 때에 이미 App 객체를 잘 만들어 보내주기 때문에 Test가치가 떨어져 구현하지 않았습니다.

- UI Test

    - UITest는 검색창에 AfreecaTV를 검색하여 결과가 나오는지를 확인하고, Detail Scene으로 넘어가 ScreenShots이 잘 scroll 되는지 확인하였습니다.
