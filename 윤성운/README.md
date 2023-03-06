# 오늘 학습한 내용

## 03.06(월)

### 1. 엔티티 매핑

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