import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import timer from "@/videos/timer.mp4";
import recipeNext from "@/videos/recipeNext.mp4";
import audioWave from "@/videos/audioWave.mp4";
import { useEffect, useState } from "react";

function VoiceRecipe() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  const [scrollLocation, setScrollLocation] = useState<number>(0);

  const windowScrollListener = (e: Event) => {
    setScrollLocation(document.documentElement.scrollTop);
    setWordIdx(Math.ceil(document.documentElement.scrollTop / 100) % 4);
  };

  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);

  const wordComponent: JSX.Element[] = [
    <h2>"코쿡, 타이머"</h2>,
    <h2>"코쿡, 다음"</h2>,
    <h2>"코쿡, 다시"</h2>,
    <h2>"코쿡, 이전"</h2>,
  ];
  const [wordIdx, setWordIdx] = useState<number>(0);

  return (
    <StyledVoiceRecipe ref={ref} inView={inView}>
      <div className="mockup">
        <div style={{ paddingLeft: scrollLocation / 7 }}>
          <Mockup isVideo={true} screen={timer} isRotate={true}></Mockup>
        </div>
        <div style={{ paddingLeft: scrollLocation / 30 }}>
          <Mockup isVideo={true} screen={recipeNext} isRotate={true}></Mockup>
        </div>
      </div>
      <div>
        <video src={audioWave} autoPlay loop muted></video>
        {wordComponent[wordIdx]}
        <p>요리 중 손을 쓰기 힘들다면 언제든 말만 하세요.</p>
      </div>
    </StyledVoiceRecipe>
  );
}

export default VoiceRecipe;

const StyledVoiceRecipe = styled.section<{ inView: boolean }>`
  display: flex;
  align-items: center;
  height: 650px;
  width: 100%;
  text-align: right;

  @media (max-width: 734px) {
    flex-direction: column-reverse;
    justify-content: center;
  }

  & > div {
    width: 40%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    @media (max-width: 734px) {
      width: 100%;
    }
    flex-shrink: 0;

    & > video {
      width: 200px;
      margin-bottom: 16px;
      mix-blend-mode: multiply;
      ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
    }

    & > h2 {
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.subtitle2}
      font-size: 2.5rem;
      text-align: center;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
    }
    & > p {
      margin-top: 16px;
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.body1}
      font-size: 1rem;
      text-align: center;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      animation: fadeUp1 0.5s ease-out;
      ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
    }
  }
  .mockup {
    width: 60%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: start;
    @media (max-width: 734px) {
      width: 100%;
      height: 50%;
      margin-left: 30px;
    }
    & > div {
      width: 60%;
      height: 30%;
      display: flex;

      align-items: center;
      @media (max-width: 734px) {
        justify-content: center;
        width: 100%;
        margin-left: -60px;
      }
      @media (min-width: 734px) {
        margin-left: 20px;
      }
      @media (min-width: 1068px) {
        margin-left: 100px;
      }
    }
  }
`;
