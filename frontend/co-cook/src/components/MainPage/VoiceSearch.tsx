import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import voiceSearch from "../../assets/videos/voiceSearch.webm";

function VoiceSearch() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  return (
    <StyledVoiceSearch id="voice-search-section" ref={ref} inView={inView}>
      <div>
        <div className="title">
          <h2>"양파, 당근, 브로콜리..."</h2>
          <p>냉장고 속이 두려울 때,</p>
          <p>재료를 말하면 레시피를 추천해드립니다.</p>
        </div>
        <div className="mockup">
          <Mockup isVideo={true} screen={voiceSearch}></Mockup>
        </div>
      </div>
    </StyledVoiceSearch>
  );
}

export default VoiceSearch;

const StyledVoiceSearch = styled.section<{
  inView: boolean;
}>`
  @keyframes contentFade {
    0% {
      opacity: 0;
      transform: translateY(50px);
    }
    100% {
      opacity: 1;
      transform: translateY(0px);
    }
  }
  display: flex;
  justify-content: center;
  height: 70vh;
  width: 100vw;
  background-image: url("/src/assets/image/refrigerator.jpg");
  background-size: auto 100vh;

  background-position: 50% 20%;
  @media (max-width: 734px) {
    height: 100vh;
  }

  & > div {
    display: flex;
    justify-content: space-between;
    margin-inline: 24px;
    width: 100%;
    max-width: 980px;
    @media (max-width: 734px) {
      flex-direction: column;
      justify-content: start;
      align-items: center;
    }

    & .title {
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: start;
      justify-content: center;
      text-align: start;
      @media (max-width: 734px) {
        align-items: center;
        justify-content: center;
        height: 40%;
        text-align: center;
      }
      & > h2 {
        margin-block: 16px;
        word-break: keep-all;
        line-height: 1.2;
        ${({ theme }) => theme.fontStyles.subtitle1}
        font-size: 2.5rem;
        transition: all ease-out 0.2s;
        ${({ inView }) =>
          inView
            ? "animation: contentFade 0.5s ease-out;"
            : "opacity: 0; transform: translateY(50px);"}
        color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
        text-shadow: 0px 0px 16px ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      }
      & > p {
        margin-block: 4px;
        line-height: 1.2;
        word-break: keep-all;
        ${({ theme }) => theme.fontStyles.body1}
        font-size: 1.5rem;
        color: ${({ theme }) => theme.Colors.MONOTONE_LIGHT};
        text-shadow: 0px 0px 16px ${({ theme }) => theme.Colors.MONOTONE_BLACK};
        ${({ inView }) =>
          inView
            ? "animation: contentFade 0.5s ease-out;"
            : "opacity: 0; transform: translateY(50px);"}
      }
    }
    & .mockup {
      position: relative;
      bottom: 0px;
      ${({ inView }) =>
        inView
          ? "animation: contentFade 1s ease-out;"
          : "opacity: 0; transform: translateY(50px);"}
      z-index: 1;
      width: 250px;
      margin-top: 50px;
      @media (max-width: 734px) {
        margin-top: -10px;
      }
    }
  }
`;
