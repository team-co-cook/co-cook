import styled from "styled-components";
import Mockup from "../common/Mockup";
import splashImg from "../../assets/image/splashImg.png";

function HeaderMockup() {
  return (
    <StyledHeaderMockup>
      <div>
        <Mockup isVideo={false} splashImg={splashImg}></Mockup>
      </div>
      <div>
        <Mockup isVideo={false} splashImg={splashImg}></Mockup>
      </div>
      <div>
        <Mockup isVideo={false} splashImg={splashImg}></Mockup>
      </div>
      <div>
        <Mockup isVideo={false} splashImg={splashImg}></Mockup>
      </div>
      <div>
        <Mockup isVideo={false} splashImg={splashImg}></Mockup>
      </div>
    </StyledHeaderMockup>
  );
}

export default HeaderMockup;

const StyledHeaderMockup = styled.div`
  display: flex;
  justify-content: center;
  position: absolute;

  left: 50%;
  transform: translate(-50%, 0%);
  width: 1000px;
  max-width: 980px;
  height: 500px;
  overflow: hidden;
  & > div {
    width: 200px;
    margin: 8px;
  }
`;
