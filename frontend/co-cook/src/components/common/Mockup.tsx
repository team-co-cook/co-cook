import styled from "styled-components";
import mockupImg from "@/image/mockupImg.png";

interface Iprops {
  isVideo: boolean;
  screen: string;
  isRotate: boolean;
}

function Mockup(props: Iprops) {
  return (
    <StyledMockup isRotate={props.isRotate}>
      <img className="mockup-img" src={mockupImg} alt="" />
      <div className="mockup-screen">
        {props.isVideo ? (
          <video className="mockup-screen-img" autoPlay={true} loop={true} muted={true}>
            <source src={props.screen} type="video/webm"></source>
          </video>
        ) : (
          <img className="mockup-screen-img" src={props.screen} alt="screen" />
        )}
      </div>
    </StyledMockup>
  );
}

export default Mockup;

const StyledMockup = styled.div<{ isRotate: boolean }>`
  z-index: -2;
  ${({ isRotate }) => (isRotate ? "transform: rotate(90deg);" : null)}

  width: 150px;
  @media (min-width: 734px) {
    width: 220px;
  }
  @media (min-width: 1068px) {
    width: 300px;
  }
  position: relative;
  aspect-ratio: 1/2.19;
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
