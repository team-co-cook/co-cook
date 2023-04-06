import styled from "styled-components";
import { useInView } from "react-intersection-observer";
import Mockup from "../common/Mockup";
import voiceSearch from "@/videos/voiceSearch.mp4";
import { useEffect, useState } from "react";

function VoiceSearch() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  const [scrollLocation, setScrollLocation] = useState<number>(0);

  const windowScrollListener = (e: Event) => {
    setScrollLocation((document.documentElement.scrollTop / 6) * -1);
  };

  useEffect(() => {
    window.addEventListener("scroll", windowScrollListener);
    return () => {
      window.removeEventListener("scroll", windowScrollListener);
    };
  }, []);

  return (
    <StyledVoiceSearch id="voice-search-section" ref={ref} inView={inView}>
      <div>
        <div className="title">
          <h2>"양파, 당근, 브로콜리..."</h2>
          <p>냉장고 속이 두려울 때,</p>
          <p>재료를 말하면 레시피를 추천해드립니다.</p>
        </div>
        <div
          style={{
            transform: `translateY(${scrollLocation}px)`,
          }}
          className="mockup"
        >
          <Mockup isVideo={true} screen={voiceSearch} isRotate={false}></Mockup>
        </div>
      </div>
    </StyledVoiceSearch>
  );
}

export default VoiceSearch;

const StyledVoiceSearch = styled.section<{
  inView: boolean;
}>`
  height: 500px;
  display: flex;
  align-items: center;
  width: 100%;
  text-align: left;
  & > div {
    display: flex;
    z-index: -3;
    width: 100%;
    height: 100%;
    background-size: cover;
    border-radius: 16px;
    @media (max-width: 734px) {
      flex-direction: column;
    }
    & > div {
      width: 65%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      @media (max-width: 734px) {
        width: 100%;
        height: 50%;
      }
      flex-shrink: 0;

      & > video {
        width: 100px;
        margin-bottom: 16px;
        mix-blend-mode: darken;
        ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
      }

      & > h2 {
        word-break: keep-all;
        ${({ theme }) => theme.fontStyles.subtitle2}
        font-size: 2.5rem;
        text-align: center;
        color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
        margin-bottom: 16px;
        line-height: 1.2;
        ${({ inView }) => (inView ? "animation: fadeUp1 0.5s ease-out;" : "opacity: 0;")}
      }
      & > p {
        margin-bottom: 8px;
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
      width: 30%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: start;
      margin-top: 200px;
      @media (max-width: 734px) {
        align-items: center;
        width: 100%;
        height: 50%;
      }
    }
  }
`;
