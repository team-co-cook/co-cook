import styled from "styled-components";
import mockupImg from "../../assets/image/mockupImg.png";

interface Iprops {
  isVideo: boolean;
  splashImg: string;
}

function Mockup(props: Iprops) {
  return (
    <StyledMockup>
      <img className="mockup-img" src={mockupImg} alt="" />
      <div className="mockup-screen">
        <img className="mockup-screen-img" src={props.splashImg} alt="" />
      </div>
    </StyledMockup>
  );
}

export default Mockup;

const StyledMockup = styled.div`
  width: 100%;
  position: relative;
  .mockup-img {
    mix-blend-mode: darken;
    position: absolute;
    top: 0px;
    left: 0px;
    margin-top: 8%;
    margin-left: 1%;
    width: 100%;
  }
  .mockup-screen {
    z-index: -1;
    position: absolute;
    border-radius: 6%;
    top: 0px;
    left: 0px;
    width: 100%;
    scale: 0.9;

    &-img {
      width: 100%;
      aspect-ratio: 1/2.17;
      border-radius: 6%;
    }
  }
`;
