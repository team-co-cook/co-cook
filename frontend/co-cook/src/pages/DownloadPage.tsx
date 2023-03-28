import { isMobile, isAndroid } from "react-device-detect";

import styled from "styled-components";
import NavBar from "../components/NavBar";

function DownloadPage() {
  return (
    <StyledDownloadPage>
      <NavBar></NavBar>
      {isMobile ? (
        isAndroid ? (
          <div>android</div>
        ) : (
          <div>ios</div>
        )
      ) : (
        <div>pc</div>
      )}
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
