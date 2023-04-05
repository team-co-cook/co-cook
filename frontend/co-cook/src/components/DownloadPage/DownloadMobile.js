import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import { useEffect, useState } from "react";
import styled from "styled-components";
import { isAndroid } from "react-device-detect";
import appIcon from "@/logo/appIcon.png";
import emailjs from "@emailjs/browser";
function DownloadMobile() {
  const [agree, setAgree] = useState(false);
  const [allInput, setAllInput] = useState(false);
  const [emailData, setEmailData] = useState({
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
  const typeInputData = (type, data) => {
    let newEmailData = emailData;
    newEmailData[type] = data;
    setEmailData(newEmailData);
    if (newEmailData["udid"] && newEmailData["name"] && newEmailData["reply_email"]) {
      setAllInput(true);
    } else {
      setAllInput(false);
    }
  };
  return _jsxs(StyledDownloadMobile, {
    children: [
      _jsx("img", { className: "app-icon", src: appIcon, alt: "app-icon" }),
      isAndroid
        ? _jsxs("div", {
            children: [
              _jsx("h1", { children: "Android\uC5D0\uC11C" }),
              _jsx("h1", { children: "Co-cook! \uC571 \uC0AC\uC6A9\uD558\uAE30" }),
              _jsx("a", {
                className: "download-btn",
                href: data.data.androidUrl,
                children: "\uB2E4\uC6B4\uB85C\uB4DC",
              }),
            ],
          })
        : _jsxs("div", {
            children: [
              _jsx("h1", { children: "iPhone\uC5D0\uC11C" }),
              _jsx("h1", { children: "Co-cook! \uC571 \uC0AC\uC6A9\uD558\uAE30" }),
              _jsx("a", {
                className: "download-btn",
                href: data.data.iosUrl,
                children: "\uB2E4\uC6B4\uB85C\uB4DC",
              }),
              _jsx("p", {
                children:
                  "\u26A0\uFE0F\uC778\uC99D\uB41C iPhone\uB9CC \uC124\uCE58\uAC00 \uAC00\uB2A5\uD569\uB2C8\uB2E4.",
              }),
              _jsx("h2", { children: "\uC778\uC99D \uC694\uCCAD \uAC00\uC774\uB4DC" }),
              _jsxs("div", {
                className: "submit-form",
                children: [
                  _jsx("p", {
                    children:
                      "\uC544\uB798 \uD504\uB85C\uD30C\uC77C\uC744 \uC124\uCE58\uD558\uACE0, \uD655\uC778\uB41C UDID\uB97C \uC544\uB798\uC5D0 \uC785\uB825 \uD6C4 \uC804\uC1A1\uD574\uC8FC\uC138\uC694.",
                  }),
                  _jsx("a", {
                    className: "download-btn",
                    href: "https://udid.tech/static/configs/udid_tech.signed.mobileconfig",
                    children: "\uD504\uB85C\uD30C\uC77C \uB2E4\uC6B4\uB85C\uB4DC",
                  }),
                  _jsx("span", { children: "UDID" }),
                  _jsx("input", {
                    onChange: (e) => {
                      typeInputData("udid", e.target.value);
                    },
                    type: "text",
                    placeholder: "00000000-XXXXXXXXXXXXXXXX",
                  }),
                  _jsx("span", { children: "\uC131\uD568" }),
                  _jsx("input", {
                    onChange: (e) => {
                      typeInputData("name", e.target.value);
                    },
                    type: "text",
                    placeholder: "\uD64D\uAE38\uB3D9",
                  }),
                  _jsx("span", { children: "\uC774\uBA54\uC77C" }),
                  _jsx("input", {
                    onChange: (e) => {
                      typeInputData("reply_email", e.target.value);
                    },
                    type: "email",
                    placeholder: "XXX@XXX.com",
                  }),
                  _jsx("p", {
                    children:
                      "\uAC1C\uC778\uC815\uBCF4 \uC218\uC9D1 \uBC0F \uC774\uC6A9\uC5D0 \uB3D9\uC758\uD574\uC8FC\uC138\uC694.",
                  }),
                  _jsxs("ul", {
                    children: [
                      _jsx("li", {
                        children:
                          "\uC218\uC9D1\uBAA9\uC801 : AD HOC \uBC30\uD3EC\uB97C \uD1B5\uD55C \uC571 \uC124\uCE58 \uAC00\uB2A5 \uC5EC\uBD80 \uD68C\uC2E0",
                      }),
                      _jsx("li", {
                        children:
                          "\uC218\uC9D1\uD56D\uBAA9 : \uC774\uB984, \uC774\uBA54\uC77C, UDID",
                      }),
                      _jsx("li", {
                        children:
                          "\uBCF4\uC720 \uBC0F \uC774\uC6A9\uAE30\uAC04 : \uC785\uB825\uC77C\uB85C\uBD80\uD130 \uD574\uB2F9 \uD504\uB85C\uC81D\uD2B8 \uC885\uB8CC\uC77C(2023. 4. 7.(\uAE08))\uAE4C\uC9C0",
                      }),
                    ],
                  }),
                  _jsxs("div", {
                    className: "submit-box",
                    children: [
                      _jsx("input", {
                        onClick: () => {
                          setAgree(!agree);
                        },
                        type: "checkbox",
                        disabled: !allInput,
                      }),
                      _jsx("label", {
                        children: "\uC704 \uB0B4\uC6A9\uC5D0 \uB3D9\uC758\uD569\uB2C8\uB2E4.",
                      }),
                      _jsx("button", {
                        onClick: () => {
                          emailjs
                            .send(
                              "service_283184v",
                              "template_t579wcq",
                              emailData,
                              "KEvNEKeXbvmtjO0QG"
                            )
                            .then((res) => {
                              console.log(res);
                              alert(
                                "신청이 완료되었습니다. 등록 완료시 작성하신 이메일로 회신해드립니다."
                              );
                            })
                            .catch((e) => {
                              console.log(e);
                              alert("요청 실패");
                            });
                        },
                        disabled: !agree || !allInput,
                        children: "\uC2E0\uCCAD",
                      }),
                    ],
                  }),
                ],
              }),
            ],
          }),
    ],
  });
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
