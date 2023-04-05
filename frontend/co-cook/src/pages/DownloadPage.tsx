import { isMobile } from "react-device-detect";

import styled from "styled-components";
import NavBar from "../components/common/NavBar";
import DownloadMobile from "../components/DownloadPage/DownloadMobile";
import DownloadPc from "../components/DownloadPage/DownloadPc";
import { useEffect } from "react";

function DownloadPage() {
  return (
    <StyledDownloadPage>
      <NavBar />
      {isMobile ? <DownloadMobile /> : <DownloadPc />}
    </StyledDownloadPage>
  );
}

export default DownloadPage;

const StyledDownloadPage = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-inline: 24px;
`;
