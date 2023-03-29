import styled from "styled-components";
import mockupImg from "../../assets/image/mockupImg.png";

interface Iprops {
  isVideo: boolean;
  screen: string;
}

function Mockup(props: Iprops) {
  return (
    <StyledMockup>
      <img className="mockup-img" src={mockupImg} alt="" />
      <div className="mockup-screen">
        {props.isVideo ? (
          <video
            className="mockup-screen-img"
            src={props.screen}
            autoPlay={true}
            loop={true}
            muted={true}
          ></video>
        ) : (
          <img className="mockup-screen-img" src={props.screen} alt="screen" />
        )}
      </div>
    </StyledMockup>
  );
}

export default Mockup;

const StyledMockup = styled.div`
  width: 100%;
  height: 100%;
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
      aspect-ratio: 1/2.19;
      border-radius: 6%;
    }
  }
`;
