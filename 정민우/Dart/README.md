# Dart

멀티플랫폼 앱 제작을 위해 구글이 만든 프로그래밍 언어.

```Dart
void main() {
  print('Hello, World!');
}
```

## 변수

```Dart
var name = 'minu';
print(name); // minu

// 값 변경

name = 'jung';
print(name); // jung

// 재선언은 불가능

var name = 'dart'; // error : The name 'name' is already defined.
```

### Integer

```Dart
// Integer type : 정수

int age = 27;
print(age); // 27
```

### Double

```Dart
// Double type : 실수

double height = 171.2;
print(height); // 171.2
```

### Boolean

```Dart
// Boolean type : 불리언

bool isAdult = true;
print(isAdult); // true
```

### String

```Dart
// String type : 문자열

String name = 'minu';
print(name); // minu
```

- String Concatenation

```Dart
// BAD

print('제 이름은' + name + '입니다.'); // 제 이름은minu입니다., info :  Use interpolation to compose strings and values.

// GOOD

print('제 이름은 $name 입니다.'); // 제 이름은 minu 입니다.
print('제 이름은 ${name.toUpperCase()} 입니다..'); // 제 이름은 MINU 입니다.
```

### List

```Dart
List nameList = ['짱구', '철수', '맹구'];
print(nameList); // ['짱구', '철수', '맹구']

// value type 미지정시 dynamic으로 기본 선언

nameList.add(32);
print(nameList); // [짱구, 철수, 맹구, 32]

// List value의 type 선언

List<int> ageList = [6, 4, 5];
print(ageList); // [6, 4, 5]

ageList.add('나이'); // error : The argument type 'String' can't be assigned to the parameter type 'int'.
```

- List index

```Dart
List nameList = ['짱구', '철수', '맹구'];
print(nameList[0]); // 짱구
```

### Map

```Dart
Map childList = {
  '짱구' : 6,
  '철수' : 4,
  '맹구' : 5,
};
print(childList); // {짱구: 6, 철수: 4, 맹구: 5}

// key, value type 미지정시 dynamic으로 기본 선언

childList[27] = '정민우';
print(childList); // {짱구: 6, 철수: 4, 맹구: 5, 27: 정민우}

// Map key, value의 type 선언

Map<String, int> childList = {
  '짱구' : 6,
  '철수' : 4,
  '맹구' : 5,
};
print(childList); // {짱구: 6, 철수: 4, 맹구: 5}

childList[27] = '정민우'; // error : The argument type 'int' can't be assigned to the parameter type 'String'., A value of type 'String' can't be assigned to a variable of type 'int'.
```

- Map Methods

```Dart
Map<String, int> childList = {
  '짱구' : 6,
  '철수' : 4,
  '맹구' : 5,
};

// 값 추가

childList['유리'] = 5;
print(childList); // {짱구: 6, 철수: 4, 맹구: 5, 유리: 5}

childList.addAll({'훈이' : 7,});
print(childList); // {짱구: 6, 철수: 4, 맹구: 5, 유리: 5, 훈이: 7}

// 값 변경

childList['짱구'] = 5;
print(childList); // {짱구: 5, 철수: 4, 맹구: 5, 유리: 5, 훈이: 7}

// 값 제거

childList.remove('훈이');
print(childList); // {짱구: 5, 철수: 4, 맹구: 5, 유리: 5}

// key, value 추출

print(childList.keys.toList()); // [짱구, 철수, 맹구, 유리]
print(childList.values.toList()); // [5, 4, 5, 5]
```

### Type Check

```Dart
// type check

age = '27' // A value of type 'String' can't be assigned to a variable of type 'int'.

// var로 선언한 경우 초기 선언값에 의해 타입이 지정됨.

var name = 'minu'

name = 27; // A value of type 'int' can't be assigned to a variable of type 'String'.

// 초기 선언값이 없을 경우 타입 체크를 하지 않지만 권장되지 않음

var name; // An uninitialized variable should have an explicit type annotation.

name = 'minu';
print(name); // minu
print(name.runtimeType); // String

name = 27;
print(name); // 27
print(name.runtimeType); // int
```

- Dynamic Type

```Dart
dynamic name = 'minu';
print(name); // minu

name = 27;
print(name); // 27

// 타입과 상관없이 변수 값을 변경할 수 있음
```

### Final, Const

```Dart
// final로 선언된 변수는 값을 변경할 수 없음.

final name = 'minu';
final int age = 27;

name = 'jung'; // The final variable 'name' can only be set once.

// const로 선언된 변수는 값을 변경할 수 없음.

const name = 'minu';
const int age = 27;

name = 'jung'; // Constant variables can't be assigned a value.
```

#### final과 const의 차이점

- final : 실행시점에 값을 결정하여 런타임시 결정되는 값도 상수로 설정할 수 있다.

```Dart
final finalTime = DateTime.now();
print(finalTime); // 2023-03-01 22:41:40.610
```

- const : 컴파일 타임에 값을 결정한다.

```Dart
const constTime = DateTime.now(); // error : Const variables must be initialized with a constant value.
```

## 조건문

### emum & switch

```Dart
enum Status {
  success,
  error
}

void main() {
  Status status = Status.success;

  switch(status) {
    case Status.success:
      print('성공');
      break;

    case Status.error:
      print('에러');
      break;

    default:
      print('해당되지 않음');
      break;
  }
}

// 성공
```

### If

```Dart
bool isAdult = false;

if (isAdult) {
  print('성인입니다.');
} else {
  print('성인이 아닙니다.');
}

// 성인이 아닙니다.
```

## 반복문

### for

```Dart
List nameList = ['짱구', '철수', '맹구'];

for (int i = 0; i < nameList.length; i++) {
  print(nameList[i]);
}

// 짱구
// 철수
// 맹구

for (String name in nameList) {
  print(name);
}

// 짱구
// 철수
// 맹구
```

### while

```Dart
List nameList = ['짱구', '철수', '맹구'];

int i = 0;

while(i < nameList.length) {
  print(nameList[i]);
  i++;
}

// 짱구
// 철수
// 맹구
```

### do while

```Dart
List nameList = ['짱구', '철수', '맹구'];

int i = 0;

do {
  print(nameList[i]);
  i++;
}while(i < nameList.length);

// 짱구
// 철수
// 맹구
```

## 함수

```Dart
void main() {
  print(plusInt(2, 1)); // 3
}

plusInt(a, b) {
  return a + b;
}
```

- Optional Parameter

```Dart
void main() {
  print(plusInt(2)); // 2
}

// [] 내부에 Params 기재, 기본값 지정 필요

plusInt(int a, [int b = 0]) {
  return a + b;
}
```

- Named Parameter

```Dart
void main() {
  print(plusInt(a: 2, b: 3)); // 5
}

// {} 내부에 Params 기재, 기본적으로 Oprional하므로, 기본값을 지정해주거나 required한 값으로 선언해줘야 함

plusInt({required int a, int b = 0}) {
  return a + b;
}
```

### Typedef

```Dart
void main() {
  calculate(1, 2, add); // 3
  calculate(1, 2, subtract); // -1
}

typedef Operation(int x, int y);

void add(int x, int y) {
  print(x + y);
}
void subtract(int x, int y) {
  print(x - y);
}
void calculate(int x, int y, Operation oper) {
  oper(x, y);
}
```

## Class

```Dart
void main() {
  Child first = Child();
  first.sayName();
}

class Child{
  String name = '짱구';

  void sayName() {
    print('제 이름은 ${this.name} 입니다.');
  }
}
```

### Constructor

```Dart
void main() {
  Child first = Child('짱구');
  first.sayName(); // 제 이름은 짱구 입니다.

  Child second = Child('맹구');
  second.sayName(); // 제 이름은 맹구 입니다.
}

class Child{
  final String name;

  Child(
    String name,
  ) : this.name = name;

  void sayName() {
    print('제 이름은 ${this.name} 입니다.');
  }
}
```
