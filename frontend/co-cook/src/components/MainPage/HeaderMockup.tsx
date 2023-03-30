import styled from "styled-components";
import Mockup from "../common/Mockup";
import splashImg from "../../assets/image/splashImg.png";
import recipeScreen from "../../assets/image/recipeScreen.png";
import themeScreen from "../../assets/image/themeScreen.png";
import voiceScreen from "../../assets/videos/voiceScreen.mp4";
import homeScreen from "../../assets/videos/homeScreen.mp4";
import { useEffect, useState } from "react";

function HeaderMockup() {
  const [scrollLocation, setScrollLocation] = useState<number>(0);

  const windowScrollListener = (e: Event) => {
    setScrollLocation(document.documentElement.scrollTop);
  };

  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);

  return (
    <div>
      <StyledHeaderMockup scrollLocation={scrollLocation}>
        <div className="move-mockup">
          <Mockup isVideo={false} screen={themeScreen}></Mockup>
        </div>
        <div>
          <Mockup isVideo={true} screen={homeScreen}></Mockup>
        </div>
        <div className="move-mockup">
          <Mockup isVideo={false} screen={splashImg}></Mockup>
        </div>
        <div>
          <Mockup isVideo={true} screen={voiceScreen}></Mockup>
        </div>
        <div className="move-mockup">
          <Mockup isVideo={false} screen={recipeScreen}></Mockup>
        </div>
      </StyledHeaderMockup>
    </div>
  );
}

export default HeaderMockup;

const StyledHeaderMockup = styled.div<{ scrollLocation: number }>`
  @keyframes fadeUp1 {
    0% {
      opacity: 0;
      transform: translateY(50px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }
  @keyframes fadeUp2 {
    0% {
      opacity: 0;
      transform: translateY(100px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }

  z-index: -1;
  display: flex;
  align-items: c;
  position: absolute;
  left: 50%;
  transform: translate(-50%, 0%);
  overflow: hidden;

  & > div {
    width: 150px;
    height: 350px;
    margin: 8px;
    animation: fadeUp1 1s ease-out;
    @media (min-width: 734px) {
      width: 220px;
      height: 520px;
    }
    @media (min-width: 1068px) {
      width: 300px;
      height: 700px;
    }
  }
  .move-mockup {
    transition: all ease-out 0.2s;
    animation: fadeUp2 1s ease-out;

    padding-top: calc(
      64px / 400 * (400 - ${({ scrollLocation }) => scrollLocation})
    );
  }
`;
