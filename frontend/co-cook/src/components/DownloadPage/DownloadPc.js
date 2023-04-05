import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import styled from "styled-components";
import { QRCodeSVG } from "qrcode.react";
import appIcon from "@/logo/appIcon.png";
function DownloadPc() {
  return _jsxs(StyledDownloadPc, {
    children: [
      _jsx("img", { className: "app-icon", src: appIcon, alt: "app-icon" }),
      _jsx("h1", {
        children: "Android \uBC0F iPhone\uC5D0\uC11C \uB2E4\uC6B4\uB85C\uB4DC\uD558\uC138\uC694",
      }),
      _jsx("div", {
        className: "qr-code",
        children: _jsx(QRCodeSVG, { value: "http://j8b302.p.ssafy.io/install" }),
      }),
    ],
  });
}
export default DownloadPc;
const StyledDownloadPc = styled.main`
  width: 100%;
  max-width: 980px;
  height: 100px;
  display: flex;
  flex-direction: column;
  align-items: center;

  .app-icon {
    margin-top: 40px;
    width: 100px;
    border-radius: 26%;
  }

  & > h1 {
    margin-top: 64px;
    margin-bottom: 80px;
    word-break: keep-all;
    ${({ theme }) => theme.fontStyles.subtitle1}
    font-size: 3rem;
    text-align: center;
  }

  .qr-code {
    padding-bottom: 100px;
  }
`;
