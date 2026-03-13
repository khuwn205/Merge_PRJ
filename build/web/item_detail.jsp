<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết bài đăng</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; padding: 20px; color: #333; }
        .wrapper { max-width: 1000px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #e9ecef; }
        .badge { padding: 5px 10px; border-radius: 4px; font-weight: bold; color: white; display: inline-block; }
        .bg-warning { background-color: #ffc107; color: #000; }
        .bg-success { background-color: #28a745; }
        .bg-danger { background-color: #dc3545; }
        .btn { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; color: white; font-weight: bold; margin: 2px;}
        .btn-approve { background-color: #28a745; }
        .btn-approve:hover { background-color: #218838; transform: scale(1.05); transition: 0.2s; }
        .btn-reject { background-color: #dc3545; }
        .btn-reject:hover { background-color: #c82333; transform: scale(1.05); transition: 0.2s; }
        .form-group input, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;}
    </style>
</head>
<body>
    <div class="wrapper">
        <h2>Chi tiết bài đăng</h2>
        <a href="my_items" style="text-decoration: none; color: #007bff; font-weight: bold;">⬅ Quay lại Các tin tôi đã đăng</a>
        <hr>

        <c:if test="${not empty sessionScope.message}">
            <script>alert('${fn:escapeXml(sessionScope.message)}');</script>
            <c:remove var="message" scope="session"/>
        </c:if>
        <c:if test="${not empty ERROR}"><p style="color:red; font-weight:bold;">${ERROR}</p></c:if>

        <c:if test="${not empty itemDetail}">
            <table>
                <tr><td width="20%"><b>Người đăng</b></td><td>${itemDetail.ownerFullName}</td></tr>
                <tr><td><b>Tiêu đề</b></td><td>${itemDetail.title}</td></tr>
                <tr><td><b>Mô tả</b></td><td>${itemDetail.description}</td></tr>
                <tr><td><b>Trạng thái</b></td>
                    <td>
                        <c:choose>
                            <c:when test="${itemDetail.status eq 'completed'}"><span class="badge bg-success">Đã hoàn thành</span></c:when>
                            <c:otherwise><span class="badge bg-warning">Đang xử lý (processing)</span></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td><b>Hình ảnh</b></td>
                    <td>
                        <c:forEach var="imgPath" items="${imagePaths}">
                            <img src="${pageContext.request.contextPath}/${imgPath}" style="max-height:200px; border-radius: 5px; margin: 5px;">
                        </c:forEach>
                    </td>
                </tr>
            </table>

            <h3 style="margin-top: 30px;">💬 Tin nhắn &amp; Yêu cầu</h3>
            <table style="text-align: center;">
                <tr>
                    <th>Người gửi</th><th>Tiêu đề</th><th>Nội dung</th><th>Thời gian</th>
                    <th>Trạng thái Yêu Cầu</th>
                    <th>Hành động (Chủ bài)</th>
                </tr>
                <c:forEach var="m" items="${itemMessages}">
                    <c:set var="msgClaim" value="${claimByClaimer[m.userId]}"/>
                    <tr>
                        <td><b>${senderNames[m.userId]}</b></td>
                        <td>${m.title}</td>
                        <td>${m.message}</td>
                        <td>${m.createdAt}</td>

                        <%-- Cột Trạng thái Yêu Cầu --%>
                        <td>
                            <c:choose>
                                <c:when test="${not empty msgClaim}">
                                    <c:choose>
                                        <c:when test="${msgClaim.status eq 'pending'}"><span class="badge bg-warning">Chưa xác nhận (Pending)</span></c:when>
                                        <c:when test="${msgClaim.status eq 'approved'}"><span class="badge bg-success">Đã chấp nhận (Approved)</span></c:when>
                                        <c:when test="${msgClaim.status eq 'rejected'}"><span class="badge bg-danger">Đã bác bỏ (Rejected)</span></c:when>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <%-- Cột Hành động --%>
                        <td>
                            <c:choose>
                                <%-- CHỦ BÀI --%>
                                <c:when test="${isItemOwner}">
                                    <c:choose>
                                        <%-- FLOW "found": giữ nguyên --%>
                                        <c:when test="${itemType eq 'found'}">
                                            <c:choose>
                                                <c:when test="${not empty msgClaim and msgClaim.status eq 'pending'}">
                                                    <form action="item_detail" method="post" style="margin:0;">
                                                        <input type="hidden" name="action" value="respond_claim">
                                                        <input type="hidden" name="item_id" value="${itemDetail.itemId}">
                                                        <input type="hidden" name="claim_id" value="${msgClaim.claimId}">
                                                        <button type="submit" name="decision" value="accept" class="btn btn-approve" onclick="return confirm('XÁC NHẬN: Bạn đồng ý DUYỆT TRẢ ĐỒ cho người này chứ?');">Approve</button>
                                                        <br>
                                                        <button type="submit" name="decision" value="reject" class="btn btn-reject" onclick="return confirm('XÁC NHẬN: Bạn muốn TỪ CHỐI yêu cầu của người này?');">Reject</button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${not empty msgClaim}">
                                                    <span style="color: green; font-weight: bold;">Đã xử lý xong</span>
                                                </c:when>
                                            </c:choose>
                                        </c:when>
                                        <%-- FLOW "lost" MỚI --%>
                                        <c:when test="${itemType eq 'lost'}">
                                            <c:choose>
                                                <c:when test="${empty msgClaim}">
                                                    <form action="item_detail" method="post" style="margin:0;">
                                                        <input type="hidden" name="action" value="owner_request_lost">
                                                        <input type="hidden" name="item_id" value="${itemDetail.itemId}">
                                                        <input type="hidden" name="claimer_id" value="${m.userId}">
                                                        <button type="submit" name="decision" value="request" class="btn btn-approve" onclick="return confirm('XÁC NHẬN: Đây là đồ của bạn? Gửi yêu cầu nhận lại?');">📦 Yêu cầu nhận lại đồ</button>
                                                        <br>
                                                        <button type="submit" name="decision" value="reject" class="btn btn-reject" onclick="return confirm('XÁC NHẬN: Đây không phải đồ của bạn?');">❌ Đây không phải đồ của tôi</button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${msgClaim.status eq 'pending'}">
                                                    <span style="color: #007bff; font-weight: bold;">Đang chờ người tìm thấy xác nhận...</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: green; font-weight: bold;">Đã xử lý xong</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                </c:when>

                                <%-- NGƯỜI GỬI TIN NHẮN (không phải chủ bài) --%>
                                <c:otherwise>
                                    <c:choose>
                                        <%-- FLOW "lost": B xác nhận sau khi A gửi yêu cầu --%>
                                        <c:when test="${itemType eq 'lost'}">
                                            <c:choose>
                                                <c:when test="${empty msgClaim}">
                                                    <span style="color: gray;">Chờ chủ bài xác nhận...</span>
                                                </c:when>
                                                <c:when test="${msgClaim.status eq 'pending'}">
                                                    <p style="color: #007bff; font-weight: bold; margin: 0 0 4px 0;">📦 Yêu cầu nhận lại đồ</p>
                                                    <form action="item_detail" method="post" style="margin:0;">
                                                        <input type="hidden" name="action" value="finder_respond_lost">
                                                        <input type="hidden" name="item_id" value="${itemDetail.itemId}">
                                                        <input type="hidden" name="claim_id" value="${msgClaim.claimId}">
                                                        <button type="submit" name="decision" value="accept" class="btn btn-approve" onclick="return confirm('XÁC NHẬN: Bạn đồng ý trả lại đồ cho chủ?');">✅ Accept</button>
                                                        <br>
                                                        <button type="submit" name="decision" value="reject" class="btn btn-reject" onclick="return confirm('XÁC NHẬN: Bạn muốn từ chối yêu cầu này?');">❌ Reject</button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: gray;">Đã xử lý</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <%-- FLOW "found": giữ nguyên --%>
                                        <c:otherwise>
                                            <c:if test="${not empty msgClaim}">Đã gửi yêu cầu</c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty itemMessages}"><tr><td colspan="6">Chưa có ai nhắn tin.</td></tr></c:if>
            </table>

            <h3 style="margin-top: 30px;">✍ Gửi Tin Nhắn</h3>
            <c:choose>
                <c:when test="${!isItemOwner}">
                    <form action="item_detail" method="post" class="form-group">
                        <input type="hidden" name="action" value="send_message">
                        <input type="hidden" name="item_id" value="${itemDetail.itemId}">
                        <p>Tiêu đề (*)<br><input type="text" name="title" required></p>
                        <p>Nội dung (*)<br><textarea name="message" rows="4" required placeholder="Đây là đồ của tôi, cho tôi xin nhận lại."></textarea></p>
                        <button type="submit" class="btn btn-approve">Gửi đi</button>
                        <c:choose>
                            <c:when test="${itemType eq 'lost'}">
                                <p style="color: gray; font-size: 13px;">* Ghi chú: Sau khi gửi tin nhắn, chủ bài sẽ xem xét và gửi Yêu cầu nhận lại đồ nếu đây là đồ của họ.</p>
                            </c:when>
                            <c:otherwise>
                                <p style="color: gray; font-size: 13px;">* Ghi chú: Khi gửi tin nhắn, hệ thống sẽ tự động tạo luôn Yêu cầu nhận lại đồ cho bạn.</p>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </c:when>
                <c:otherwise>
                    <p style="color: #dc3545; font-weight: bold;">❌ Bạn là chủ bài đăng, không thể tự gửi tin nhắn cho chính bài viết của mình.</p>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
</body>
</html>
