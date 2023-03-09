# 프로젝트 구조

```
📦 co_cook
├─ android/
├─ assets/
│  ├─ images/
│  │  └─ ...
│  └─ fonts/
│     └─ ...
├─ ios/
└─ lib/
   ├─ providers/
   │  ├─ auth_provider.dart
   │  └─ ...
   ├─ screens/
   │  ├─ screen1/
   │  │  ├─ screen1.dart
   │  │  └─ widgets/
   │  │     ├─ local_widget1.dart
   │  │     ├─ local_widget2.dart
   │  │     └─ ...
   │  └─ ...
   ├─ services/
   │  ├─ feature1.dart
   │  ├─ feature2.dart
   │  └─ ...
   ├─ styles/
   │  ├─ colors.dart
   │  └─ fonts.dart
   ├─ utils/
   │  ├─ feature1.dart
   │  ├─ feature2.dart
   │  └─ ...
   ├─ widgets/
   │  ├─ button/
   │  │  ├─ button1.dart
   │  │  ├─ button2.dart
   │  │  └─ ...
   │  ├─ input/
   │  │  ├─ input1.dart
   │  │  ├─ input2.dart
   │  │  └─ ...
   │  └─ ...
   └─ main.dart
```

# 이름 규칙

## 폴더, 파일 명 규칙

- snake_case

## 코드 스타일 규칙

- 함수 : PascalCase, 동사로 시작

  - 예) getUserData, addIngredientsTag ...

- 변수 : camelCase, 명사, 선언

  - 예) userName, recipeId ...

  - List : 변수명 + List

    - 예) mainRecipeList ...

- id값 : 변수명 + Id

  - 예) userId ...
