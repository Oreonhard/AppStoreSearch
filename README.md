# App Store 검색 기능

자주 사용하는 App Store 의 검색 탭 구현을 해 보았습니다.  
사용한 API 는 Apple 에서 제공하는 [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1) 를 사용하였습니다.

세밀한 부분까지 디자인을 맞추려다보니 기능 구현보다 디자인에 더욱 시간을 많이 썼던 것 같습니다.  
처음 MVVM 패턴을 사용해보았는데, 지금와서 보니 깔끔하게 구조를 구분하지 못한 것 같아 아쉬움이 있습니다.

다른 iOS 앱 프로젝트의 MVVM 구조를 참고하여 이후 새로운 프로젝트나 현재 프로젝트에서  
MVVM 패턴을 예쁘게 사용해보고자 합니다.

## 기술 스택

- Swift
- Alamofire (HTTP 네트워킹 라이브러리)
- Kingfisher (이미지 캐싱 라이브러리)
- Cosmos (별점 UI 라이브러리)

## 앱 시현
<img src="https://github.com/Oreonhard/AppStoreSearch/blob/main/README/app.gif?raw=true" height="900px"></img>
