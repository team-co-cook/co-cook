import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import timer from "../../assets/videos/timer.webm";
import recipeNext from "../../assets/videos/recipeNext.webm";
import audioWave from "../../assets/videos/audioWave.mp4";

function VoiceRecipe() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  return (
    <StyledVoiceRecipe ref={ref} inView={inView}>
      <div className="mockup-box">
        <div className="mockup">
          <Mockup isVideo={true} screen={timer}></Mockup>
        </div>
        <div className="mockup">
          <Mockup isVideo={true} screen={recipeNext}></Mockup>
        </div>
      </div>

      <div>
        <video className="bg-video" src={audioWave} loop autoPlay muted></video>
        <h2>"코쿡, 타이머"</h2>
        <p>요리 중 손을 쓰기 힘들다면 언제든 말만 하세요.</p>
      </div>
    </StyledVoiceRecipe>
  );
}

export default VoiceRecipe;

const StyledVoiceRecipe = styled.section<{ inView: boolean }>`
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
  @keyframes contentFadeH {
    0% {
      opacity: 0;
      transform: translatex(-50px) rotate(90deg);
    }
    100% {
      opacity: 1;
      transform: translateX(0px) rotate(90deg);
    }
  }
  height: 500px;
  width: 100%;
  max-width: 980px;
  justify-content: space-between;
  display: flex;
  @media (max-width: 734px) {
    flex-direction: column-reverse;
    justify-content: center;
    align-items: center;
    height: 650px;
  }
  & > div {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: end;
    height: 100%;
    text-align: end;
    @media (max-width: 734px) {
      align-items: center;
      text-align: center;
    }
    & > h2 {
      margin-block: 16px;
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.subtitle1}
      font-size: 2.5rem;
      ${({ inView }) =>
        inView
          ? "animation: contentFade 0.5s ease-out;"
          : "opacity: 0; transform: translateY(50px);"}
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
    }
    & > p {
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.body1}
      font-size: 1.5rem;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      ${({ inView }) =>
        inView
          ? "animation: contentFade 0.5s ease-out;"
          : "opacity: 0; transform: translateY(50px);"}
    }
  }

  & .mockup-box {
    display: flex;
    flex-direction: column;
    margin-left: 80px;
    & > div:first-child {
      margin-bottom: 24px;
      animation-duration: 1s;
    }
    & > div:last-child {
      margin-right: 90px;
    }
    @media (max-width: 734px) {
      align-items: center;
      justify-content: center;
      margin-left: 450px;
      & > div:last-child {
        margin-right: 300px;
      }
    }
  }

  & .mockup {
    height: 150px;
    transform: rotate(90deg);
    position: relative;
    bottom: 0px;
    ${({ inView }) =>
      inView
        ? "animation: contentFadeH 0.5s ease-out;"
        : "opacity: 0; transform: translateY(50px);"}
    z-index: 1;
    width: 250px;
    margin-top: 50px;
    @media (max-width: 734px) {
      width: 200px;
      height: 150px;
      margin-top: -10px;
      align-items: center;
      justify-content: center;
    }
  }

  .bg-video {
    z-index: -2;
    width: 100%;
    mix-blend-mode: darken;
    max-width: 600px;
    height: 80px;
    left: 0;
    object-fit: cover;
    margin-bottom: 16px;
  }
`;
