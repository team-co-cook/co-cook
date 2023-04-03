import styled from "styled-components";
import { useInView } from "react-intersection-observer";

function PhotoSearch() {
  const { ref, inView, entry } = useInView({
    threshold: 0.8,
    triggerOnce: true,
  });

  return (
    <StyledPhotoSearch ref={ref} inView={inView}>
      <div>
        <h2>찰칵 찍어 레시피 확인</h2>
        <p>내 앞에 있는 음식의 레시피가 궁금하신가요? 사진만 찍어보세요.</p>
      </div>
    </StyledPhotoSearch>
  );
}

export default PhotoSearch;

const StyledPhotoSearch = styled.section<{ inView: boolean }>`
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
  height: 60vh;
  width: 100%;
  max-width: 980px;
  & > div {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100%;
    & > h2 {
      margin-block: 16px;
      word-break: keep-all;
      ${({ theme }) => theme.fontStyles.subtitle1}
      font-size: 2.5rem;
      text-align: start;
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
      text-align: start;
      color: ${({ theme }) => theme.Colors.MONOTONE_BLACK};
      ${({ inView }) =>
        inView
          ? "animation: contentFade 0.5s ease-out;"
          : "opacity: 0; transform: translateY(50px);"}
    }
  }
`;
