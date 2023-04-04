import styled from "styled-components";
import { QRCodeSVG } from "qrcode.react";
import appIcon from "../../assets/logo/appIcon.png";

function DownloadPc() {
  return (
    <StyledDownloadPc>
      <img className="app-icon" src={appIcon} alt="app-icon" />
      <h1>Android 및 iPhone에서 다운로드하세요</h1>
      <div className="qr-code">
        <QRCodeSVG value={"http://j8b302.p.ssafy.io/install"} />
      </div>
    </StyledDownloadPc>
  );
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
