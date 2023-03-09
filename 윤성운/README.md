# 오늘 학습한 내용

## 03.06(월)

### 엔티티 매핑

#### 객체와 테이블 매핑

`@Entity`가 붙은 클래스는 JPA가 관리하는 엔티티가 된다.

기본 생성자(파라미터가 없는 public 또는 protected)를 필수로 사용해야 한다.

`name` 속성을 이용해 JPA에서 사용할 엔티티 이름을 지정할 수 있다. (기본값: 클래스 이름)

`@Table` 어노테이션을 이용해 엔티티와 매핑할 테이블을 지정할 수 있다.

- `@Table` 속성
	- `name`: 매핑할 테이블 이름(기본값: 엔티티 이름)
	- `catalog`: 데이터베이스 catalog 매핑
	- `schema`: 데이터베이스 schema 매핑
	- `uniqueConstraints(DDL)`: DDL 생성 시에 유니크 제약 조건 생성

```java
@Entity
// @Entity(name = "Member") 같은 클래스명이 없으면 기본값 사용 권장
// @Table(name = "MBR") 매핑할 테이블의 이름을 직접 지정 가능하다.
public class Member {

}
```

#### 데이터베이스 스키마 자동 생성

Hibernate는 DB 스키마 자동 생성 기능을 제공한다.

`persistence.xml` 파일 내 `hibernate.hdm2ddl.auto` property를 생성하면 스키마 자동 생성을 이용할 수 있다.

즉 **`@Entity`를 이용해 엔티티로 설정한 클래스는 별도의 SQL문 없이도 DB에 스키마를 자동으로 생성**한다.

`value`에 따른 기능은 다음과 같다.

- `create`: 기존 테이블 삭제 후 다시 생성 (DROP + CREATE)
- `create-drop`: create와 같으나 종료시점에 테이블 DROP
- `update`: 변경분만 반영
- `validate`: 엔티티와 테이블이 정상 매핑되었는지만 확인
- `none`: 사용하지 않음

**주의: 운영 장비에는 절대 create, create-drop, update를 사용하면 안된다.**

#### 필드와 컬럼 매핑

다음과 같은 어노테이션을 통해 필드와 컬럼을 매핑할 수 있다.

- `@Column`
	- 컬럼과 매핑
	
	|속성|설명|기본값|
	|--|--|--|
	|`name`|필드와 매핑할 테이블 컬럼 이름|객체 필드 이름|
	|`insertable`, `updatable`|등록, 변경 가능 여부|TRUE|
	|`nullable`(DDL)|false: not null, true: null 허용||
	|`unique`(DDL)|유니크 제약 조건||
	|`columnDefinition`(DDL)|컬럼 정보 직접 작성||
	|`length`(DDL)|문자 길이 제약 조건(String에만 사용)|255|
	|`precision`, `scale`(DDL)|BigDecimal, BigInteger에 사용|precision=19, scale=2|

- `@Enumerated`
	- 자바 enum 타입을 매핑할 때 사용
	- 속성
		- `EnumType.ORDINAL`: enum 순서를 데이터베이스에 저장 (기본값)
		- `EnumType.STRING`: enum 이름를 데이터베이스에 저장
	- **주의: ORDINAL 사용 x (이후 enum 순서가 바뀌면 혼동 가능)**

- `@Temporal`
	- 날짜 타입(java.util.Date, java.util.Calendar)을 매핑할 때 사용
	- LocalDate, LocalDateTime을 사용할 때는 생략 가능 (최신 하이버네이트 지원)
	- 속성
		- `TemporalType.DATE`: date 타입과 매핑 (예: 2023-02-24)
		- `TemporalType.TIME`: time 타입과 매핑 (예: 10:12:30)
		- `TemporalType.TIMESTAMP`: timestamp 타입과 매핑 (예: 2023-02-24 10:12:30)

- `@Lob`
	- 데이터베이스 BLOB, CLOB 타입과 매핑
	- CLOB: String, char[], java.sql.CLOB
	- BLOB: byte[], java.sql.BLOB
	
- `@Transient`
	- 메모리상에서만 임시로 어떤 값을 보관하고 싶을 때 사용
	- 데이터베이스에 저장 및 조회되지 않는다.

```java
package hellojpa; 

import javax.persistence.*; 
import java.time.LocalDate; 
import java.time.LocalDateTime; 
import java.util.Date; 

@Entity 
public class Member { 

    @Id 
    private Long id; 
    
    @Column(name = "name") 
    private String username; 
    
    private Integer age; 
    
    @Enumerated(EnumType.STRING) 
    private RoleType roleType; 
    
    @Temporal(TemporalType.TIMESTAMP) 
    private Date createdDate; 
    
    @Temporal(TemporalType.TIMESTAMP) 
    private Date lastModifiedDate; 
    
    private LocalDateTime localDateTime;
    
    @Lob 
    private String description; 
    
    @Transient
    private Integer tmp;
}
```

## 03.07(화)

### 연관관계 매핑

#### 단방향 연관관계

<img src="https://user-images.githubusercontent.com/109272360/221084821-7f9b8ab9-ef54-43ff-a3ec-7f1e0352e318.png" width="550px">

```java
@Entity
public class Member {

    @Id @GeneratedValue
    private Long id;

    @Column(name = "USERNAME")
    private String name;
    
    private int age;
    
		// Team과의 연관관계 생성
    @ManyToONE
    @JoinColumn(name = "TEAM_ID") // 테이블에서의 외래키
    private Team team

		// getter, setter
}
```

```java
@Entity
public class Team {

    @Id @GeneratedValue
    private Long id;

    private String name;

		// getter, setter
}
```

- 연관관계 저장하기
	```java
	// 팀 저장
	Team team = new Team();
	team.setName("TeamA");
	em.persist(team);

	// 회원 저장
	Member member = new Member();
	member.setName("member1");
	member.setTeam(team); // 단방향 연관관계 설정
	em.persist(member);
	```

- 참조로 연관관계 조회하기
	```java
	// 조회
	Member findMember = em.find(Member.class, member.getId());

	// 참조를 사용해서 연관관계 조회
	Team findTeam = findMember.getTeam();
	```

- 연관관계 수정
	```java
	// 새로운 팀 저장
	Team teamB = new Team();
	teamB.setName("TeamB");
	em.persist(teamB);

	// 회원1에 새로운 팀 설정
	// persist() 없이도 자동 반영
	member.setTeam(teamB);
	```

#### 양방향 연관관계

<img src="https://user-images.githubusercontent.com/109272360/221085893-86898fb8-4a98-43c5-9d42-1b9ffa7d8f2a.png" width="550px">

```java
@Entity
public class Member {

    @Id @GeneratedValue
    private Long id;

    @Column(name = "USERNAME")
    private String name;
    
    private int age;
    
		// Team과의 연관관계 생성
    @ManyToONE
    @JoinColumn(name = "TEAM_ID")
    private Team team

		// getter, setter
}
```

```java
@Entity
public class Team {

    @Id @GeneratedValue
    private Long id;

    private String name;

		// 양방향 매핑
		// mappedBy: 반대편 엔티티가 참조하는 이름
		@OneToMany(mappedBy = "team")
		List<Member> members = new ArrayList<Member>();

		// getter, setter
}
```

- 양방향 매핑
	```java
  Team team = new Team();
  team.setName("teamA");
  em.persist(team);

  Member member = new Member();
  member.setUsername("member1");
  member.setAge(20);
	member.setTeam(team);
  em.persist(member);

	// flush & clear 작업을 하지 않으면 엔티티 매니저는 team을 영속성 컨텍스트에서 가져온다.
	// 영속성 컨텍스트에서의 team은 바뀐 member를 인식하지 못한다. (member에만 team을 추가했기 때문)
	// 따라서 flush 후 영속성 컨텍스트를 비우면 DB에서 갱신된 team을 가져올 수 있다.
	em.flush();
	em.clear();

  Team findTeam = em.find(Team.class, team.getId());
	int memberSize = findTeam.getMembers().size(); // 역방향 조회
	```

## 03.08(수)

### 연관관계의 주인

객체끼리 연관관계를 맺기 위해서는 한 객체가 다른 객체의 정보를 갖고 있어야 한다.

따라서 다른 객체와 연관관계를 맺을 **연관관계 주인**을 정해야 하는데, 연관관계 주인은 주로 **테이블 상에서 외래키를 갖고 있는 곳**으로 정한다.

(비지니스 로직을 기준으로 정하지 않는다.)

이렇게 연관관계 주인을 정한 뒤, 연관관계 주인이 맺은 단방향 매핑만으로도 연관관계 매핑은 완료된다.

따라서 우선적으로 단방향 매핑 후 양방향 매핑은 필요 시 추가해도 무방하다.

(양방향 매핑은 반대 방향으로의 조회 기능이 추가된 것 뿐)

### 다양한 연관관계 매핑

- **일대일 (1:1)**
	- 외래키를 갖고 있는 객체에 `@OneToOne` 사용
	- 양방향 매핑 시 반대편 객체에 `@OneToOne(mappedBy = "참조하는 속성명")` 사용

- **다대일 (N:1)**
	- 외래키를 갖고 있는 객체(N)에 `@ManyToOne` 사용
	- 양방향 매핑 시 반대편 객체(1)에 `@OneToMany(mappedBy = "참조하는 속성명")` 사용

- **다대다 (N:M)**
	- `@ManyToMany`이 있지만 실무에서는 거의 사용 x

		다대다로 연결된 테이블은 중개 테이블을 생성한다.

		이때 중개 테이블은 두 엔티티의 id를 갖고 있는데, 여기에 추가적인 컬럼이 필요할 수도 있다.

		이러한 경우 `@ManyToMany`의 사용이 불가능하다.

		따라서 **중개 테이블용 엔티티를 추가한 뒤 두 엔티티와 연결**시킨다.

	- 중개 테이블용 엔티티에서 N:M으로 연결시키고자 하는 두 엔티티를 `@ManyToOne`으로 추가한다.

		(두 테이블의 id는 중개 테이블이 갖고 있음)

		두 엔티티는 `@OneToMany(mappedBy = "참조하는 속성명")`으로 중개 테이블을 추가한다.
	
### 상속관계 매핑

상속관계 매핑이란 슈퍼타입 서브타입 논리 모델을 실제 물리 모델로 구현하는 방법이다.

슈퍼타입 엔티티는 `@Inheritance(strategy=InheritanceType.타입명)`으로 슈퍼타입임을 명시한다.

서브타입 엔티티는 슈퍼타입 엔티티를 `extends`로 상속받는다.

```java
@Entity
@Inheritance(strategy=InheritanceType.타입명)
// 슈퍼타입 테이블에 현재 데이터가 어떤 서브타입의 데이터인지 정보를 추가할 수 있다.
// @DiscriminatorColumn(name="xxx") (name 안 적을 시 기본값: DTYPE)
public class Item {
	
    @Id @GeneratedValue
    private Long id;

    private String name;
    private int price;

    // getter, setter
}
```

```java
@Entity
// 슈퍼타입 테이블의 DTYPE 컬럼에 현재 서브타입을 어떻게 명시할지 정할 수 있다.
// 어노테이션 사용하지 않으면 기본값: 현재 엔티티명
// @DiscriminatorValue("xxx")
public class Album extends Item {
    private String artist;

    // artist에 대한 getter, setter
}
```

<img src="https://user-images.githubusercontent.com/109272360/221390690-f88c1d5b-1581-4b5b-8c7f-9cceb234fdaa.png" width="550px">

- 조인 전략
	- `JOINED` type 사용
	- 장점
		- 테이블 정규화
		- 외래키 참조 무결성 제약조건 활용 가능
		- 저장공간 효율화
	- 단점
		- 조회시 조인을 많이 사용 -> 성능 저하
		- 조회 쿼리가 복잡함
		- 데이터 저장시 INSERT SQL 2번 호출

	<img src="https://user-images.githubusercontent.com/109272360/221390730-a3443d4f-3650-4dda-b236-e8da8693966d.png" width="550px">

- 단일 테이블 전략
	- `SINGLE_TABLE` type 사용
	- `@DiscriminatorColumn`을 명시하지 않아도 `DTYPE`이 테이블에 자동으로 들어감
	- 장점
		- 조인이 필요 없으므로 일반적으로 조회 성능이 빠름
		- 조회 쿼리가 단순함
	- 단점
		- 자식 엔티티가 매핑한 컬럼은 모두 null 허용
		- 단일 테이블에 모든 것을 저장하므로 상황에 따라 조회 성능이 오히려 느려질 수 있음
	
	<img src="https://user-images.githubusercontent.com/109272360/221390803-9faf1a5e-9f3c-4caf-b994-debea92c636d.png" width="200px">

- 구현 클래스마다 테이블 전략
	- `TABLE_PER_CLASS` type 사용
	- 슈퍼타입 엔티티를 `abstract`를 이용해 추상 클래스로 생성
	- 데이터베이스 설계자와 ORM 전문가 둘 다 추천하지 않는 방식
	- 장점
		- 서브 타입을 명확하게 구분해서 처리할 때 효과적
		- not null 제약조건 활용 가능
	- 단점
		- 여러 자식 테이블을 함께 조회할 때 성능이 느림
		- 자식 테이블을 통합해서 쿼리하기 어려움

	<img src="https://user-images.githubusercontent.com/109272360/221390892-5fb38e90-fb5f-4967-bda3-1164aa36204b.png" width="550px">

### MappedSuperclass

두 개 이상의 엔티티가 공통 속성을 갖고 있을 때, 각 엔티티마다 속성을 명시하기 번거로울 수 있다.

이런 상황에서 공통 속성을 한 엔티티가 관리하고 다른 엔티티들이 상속을 받을 수 있다.

공통 속성을 갖는 엔티티에 `@MappedSuperclass`를 사용하면 상속받는 클래스에 속성만 제공하며, 부모 클래스는 조회, 검색이 불가능하다.

직접 생성해서 사용할 일이 없으므로 **추상 클래스**로 생성하는 것을 권장한다.

<img src="https://user-images.githubusercontent.com/109272360/221391797-a6cff766-2979-4c38-9e58-a306fdb031a5.png" width="600px">


```java
@MappedSuperClass
public abstract class BaseEntity {
    private String createBy;
    private LocalDateTime createdDate;
    private String lastModifiedBy;
    private LocalDateTime lastModifiedDate;

    // getter, setter
}
```

```java
@Entity
public class Member extends BaseEntity {
    private String name;

    // getter, setter
}
```

## 03.09(목)

### 값 타입

JPA의 데이터 타입을 분류하면 다음과 같다.

- 엔티티 타입
  - `@Entity`로 정의하는 객체
  - 데이터가 변해도 식별자로 지속해서 추적 가능
- 값 타입
  - int, Integer, String 처럼 단순히 값으로 사용하는 자바 기본 타입이나 객체
  - 식별자가 없고 값만 있으므로 변경시 추적 불가

값 타입은 다시 다음과 같이 분류할 수 있다.

- 기본값 타입
  - 자바 기본 타입(int, double)
  - 래퍼 클래스(Integer, Long)
  - String
- 임베디드 타입(embedded type, 복합 값 타입)
- 컬렉션 값 타입(collection value type)

값 타입은 **생명 주기를 엔티티에 의존**한다.

또한 하나의 값 타입이 여러 곳에서 사용되지 않도록 **절대 공유하지 않아야 한다.**

(한 객체의 속성을 변경했을 때 다른 객체의 속성이 같이 변경되는 side effect 발생 가능)

#### 기본값 타입

자바 기본 타입, 래퍼 클래스, String이 기본값 타입에 해당된다.

#### 임베디드 타입

새로운 값 타입을 직접 정의할 수 있다.

만약 `Member` 엔티티가 `city`, `street`, `zipcode` 속성을 가지고 있다면, 이 세 속성은 `Address`라는 타입으로 묶어서 관리할 수 있다.

`@Embeddable`로 값 타입을 정의하고, `@Embedded`로 정의한 값 타입을 사용할 수 있다.

생성한 임베디드 타입은 **기본 생성자를 필수로 넣어야 한다.**

임베디드 타입은 재사용성과 높은 응집도를 가지고 있어, 타입 내부에서 해당 타입에 관한 메소드를 작성할 수 있다.

임베디드 타입을 사용해도 테이블의 컬럼에는 차이가 없다.

<img src="https://user-images.githubusercontent.com/109272360/221508147-b1f5aca9-366e-4ee0-8d42-fa0d55baa705.png" width="400px">

```java
@Entity
public class Member {
    
    @Id @GeneratedValue
    private Long id;

    private String name;

    @Embedded
    private Address address;

	// getter, setter
}
```

```java
@Embeddable
public class Address {

    private String city;
    private String street;
    private String zipcode;

    // 기본 생성자를 필수로 넣어야 한다.
    public Address() {

	}

    public Address(String city, String street, String zipcode) {
        this.city = city;
        this.street = street;
        this.zipcode = zipcode;
    }

    // getter, setter
}
```

```java
Member member = new Member();
// setter의 인자로 해당 임베디드 타입을 넣는다.
member.setAddress(new Address("city", "street", "zipcode"));
```