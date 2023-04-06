import { useEffect, useState } from "react";
import styled from "styled-components";
import { isAndroid } from "react-device-detect";
import appIcon from "@/logo/appIcon.png";
import emailjs from "@emailjs/browser";

type IEmailData = {
  [name: string]: string;
};

function DownloadMobile() {
  const [agree, setAgree] = useState<boolean>(false);
  const [allInput, setAllInput] = useState<boolean>(false);
  const [emailData, setEmailData] = useState<IEmailData>({
    udid: "",
    name: "",
    reply_email: "",
  });

  let [data, setData] = useState({
    data: {
      androidUrl: "",
      iosUrl: "",
      id: 0,
    },
    message: "",
    status: 0,
  });
  async function request() {
    const response = await fetch("http://j8b302.p.ssafy.io:8080/api/v1/search/url", {
      method: "GET",
    });
    setData(await response.json());
  }

  useEffect(() => {
    request();
  }, []);

  const typeInputData = (type: string, data: string) => {
    let newEmailData = emailData;
    newEmailData[type] = data;
    setEmailData(newEmailData);
    if (newEmailData["udid"] && newEmailData["name"] && newEmailData["reply_email"]) {
      setAllInput(true);
    } else {
      setAllInput(false);
    }
  };

  return (
    <StyledDownloadMobile>
      <img className="app-icon" src={appIcon} alt="app-icon" />
      {isAndroid ? (
        <div>
          {/* android */}
          <h1>Android에서</h1>
          <h1>Co-cook! 앱 사용하기</h1>
          <a className="download-btn" href={data.data.androidUrl}>
            다운로드
          </a>
        </div>
      ) : (
        <div>
          {/* ios */}
          <h1>iPhone에서</h1>
          <h1>Co-cook! 앱 사용하기</h1>
          <a className="download-btn" href={data.data.iosUrl}>
            다운로드
          </a>
          <p>⚠️인증된 iPhone만 설치가 가능합니다.</p>
          <h2>인증 요청 가이드</h2>
          <div className="submit-form">
            <p>아래 프로파일을 설치하고, 확인된 UDID를 아래에 입력 후 전송해주세요.</p>
            <a
              className="download-btn"
              href="https://udid.tech/static/configs/udid_tech.signed.mobileconfig"
            >
              프로파일 다운로드
            </a>

            <span>UDID</span>
            <input
              onChange={(e) => {
                typeInputData("udid", e.target.value);
              }}
              type="text"
              placeholder="00000000-XXXXXXXXXXXXXXXX"
            />
            <span>성함</span>
            <input
              onChange={(e) => {
                typeInputData("name", e.target.value);
              }}
              type="text"
              placeholder="홍길동"
            />
            <span>이메일</span>
            <input
              onChange={(e) => {
                typeInputData("reply_email", e.target.value);
              }}
              type="email"
              placeholder="XXX@XXX.com"
            />
            <p>개인정보 수집 및 이용에 동의해주세요.</p>
            <ul>
              <li>수집목적 : AD HOC 배포를 통한 앱 설치 가능 여부 회신</li>
              <li>수집항목 : 이름, 이메일, UDID</li>
              <li>보유 및 이용기간 : 입력일로부터 해당 프로젝트 종료일(2023. 4. 7.(금))까지</li>
            </ul>
            <div className="submit-box">
              <input
                onClick={() => {
                  setAgree(!agree);
                }}
                type="checkbox"
                disabled={!allInput}
              />
              <label>위 내용에 동의합니다.</label>
              <button
                onClick={() => {
                  emailjs
                    .send("service_283184v", "template_t579wcq", emailData, "KEvNEKeXbvmtjO0QG")
                    .then((res) => {
                      console.log(res);
                      alert("신청이 완료되었습니다. 등록 완료시 작성하신 이메일로 회신해드립니다.");
                    })
                    .catch((e) => {
                      console.log(e);
                      alert("요청 실패");
                    });
                }}
                disabled={!agree || !allInput}
              >
                신청
              </button>
            </div>
          </div>
        </div>
      )}
    </StyledDownloadMobile>
  );
}

export default DownloadMobile;

const StyledDownloadMobile = styled.main`
  width: 100%;
  max-width: 980px;
  height: 100px;
  display: flex;
  flex-direction: column;
  align-items: center;

  .app-icon {
    margin-top: 64px;
    margin-bottom: 32px;
    width: 100px;
    border-radius: 26%;
  }

  & > div {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-bottom: 140px;
    & > h1 {
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.subtitle1}
      font-size: 2rem;
      text-align: center;
      &:first-child {
        margin-bottom: 8px;
      }
    }
    & > p {
      margin-top: 48px;
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.caption}
      font-size: 0.8rem;
      text-align: center;
      color: ${({ theme }) => theme.Colors.MONOTONE_GRAY};
    }
    & > h2 {
      margin-top: 24px;
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.subtitle1}
      font-size: 1rem;
      text-align: center;
      color: ${({ theme }) => theme.Colors.RED_PRIMARY};
    }
    & span {
      margin-bottom: 4px;
      ${({ theme }) => theme.fontStyles.caption}
      color: ${({ theme }) => theme.Colors.RED_PRIMARY};
    }
    & > div p {
      margin-top: 24px;
      margin-bottom: 16px;
      word-break: keep-all;
      font-size: 0.8rem;
      ${({ theme }) => theme.fontStyles.subtitle2}
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    }
    & li {
      margin-bottom: 8px;
      word-break: keep-all;
      font-size: 0.8rem;
      ${({ theme }) => theme.fontStyles.body2}
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    }
    & label {
      margin-left: 8px;
      word-break: keep-all;
      font-size: 0.8rem;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      ${({ theme }) => theme.fontStyles.body2}
    }
    & a {
      margin-bottom: 24px;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      text-align: center;
      text-decoration: none;
      ${({ theme }) => theme.fontStyles.button}
    }
    & input {
      margin-bottom: 8px;
      height: 24px;
      ${({ theme }) => theme.fontStyles.caption}
    }
  }
  .submit-box {
    display: flex;
    align-items: center;
    height: 40px;
    & input {
      margin-bottom: 0px;
    }

    & > button {
      margin-left: 16px;
    }
  }
  .submit-form {
    display: flex;
    flex-direction: column;
    max-width: 360px;
  }

  .download-btn {
    margin-top: 64px;
    padding: 12px 20px;
    border-radius: 16px;
    background-color: ${({ theme }) => theme.Colors.RED_PRIMARY};
    ${({ theme }) => theme.fontStyles.Button}
    color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    text-decoration: none;
    cursor: pointer;
    transition: all 0.1s;
    &:hover {
      background-color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
    }
    &:active {
      scale: 0.95;
    }
  }

  .qr-code {
    padding-bottom: 100px;
  }
  .guide {
    margin-top: 8px;
    word-break: keep-all;
    ${({ theme }) => theme.fontStyles.caption}
    font-size: 0.8rem;
    text-align: center;
    color: ${({ theme }) => theme.Colors.RED_PRIMARY};
    cursor: pointer;
  }
`;
