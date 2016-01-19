<%@ page session="false" language="java" pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="a" uri="/WEB-INF/app.tld"%>
<%@ taglib prefix="w" uri="http://www.unidal.org/web/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="res" uri="http://www.unidal.org/webres"%>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<jsp:useBean id="ctx" type="com.dianping.cat.report.page.transaction.Context" scope="request" />
<jsp:useBean id="payload" type="com.dianping.cat.report.page.transaction.Payload" scope="request" />
<jsp:useBean id="model"	type="com.dianping.cat.report.page.transaction.Model" scope="request" />
<c:set var="report" value="${model.report}"/>

<a:report>
<jsp:attribute name="subtitle">${w:format(report.startTime,'yyyy-MM-dd HH:mm:ss')} to ${w:format(report.endTime,'yyyy-MM-dd HH:mm:ss')}</jsp:attribute>
<jsp:attribute name="resource">
	<script src="${model.webapp}/js/baseGraph.js"></script>
	<script src="${model.webapp}/js/appendHostname.js"></script>
</jsp:attribute>
<jsp:body>

<table class="machines">
	<tr class="left">
		<th>&nbsp;[&nbsp;
		    <c:choose>
				<c:when test="${model.ipAddress eq 'All'}">
					<a href="?domain=${model.domain}&date=${model.date}&type=${payload.encodedType}&queryname=${model.queryName}"
						class="current">All</a>
				</c:when>
				<c:otherwise>
					<a href="?domain=${model.domain}&date=${model.date}&type=${payload.encodedType}&queryname=${model.queryName}">All</a>
				</c:otherwise>
			</c:choose> &nbsp;]&nbsp;
			<c:forEach var="ip" items="${model.ips}">
			    &nbsp;[&nbsp;
   	  		    <c:choose>
					<c:when test="${model.ipAddress eq ip}">
						<a href="?domain=${model.domain}&ip=${ip}&date=${model.date}&type=${payload.encodedType}&queryname=${model.queryName}"
							class="current">${ip}</a>
					</c:when>
					<c:otherwise>
						<a href="?domain=${model.domain}&ip=${ip}&date=${model.date}&type=${payload.encodedType}&queryname=${model.queryName}">${ip}</a>
					</c:otherwise>
				</c:choose>
   	 		    &nbsp;]&nbsp;
			 </c:forEach>
		</th>
	</tr>
</table>
<script type="text/javascript">
	$(document).ready(function() {
		appendHostname(${model.ipToHostnameStr});
	});
</script>
<table class="groups">
	<tr class="left">
		<th> 
			<c:forEach var="group" items="${model.groups}">
	   	  		&nbsp;[&nbsp;
	   	  			<a href="?op=groupReport&domain=${model.domain}&date=${model.date}&group=${group}">${group}</a>
	   	 		&nbsp;]&nbsp;
			 </c:forEach>
		</th>
	</tr>
</table>
<table class='table table-striped table-condensed table-hover '  style="width:100%;">
	<c:choose>
		<c:when test="${empty payload.type}">
			<c:set var="urlPrefix" value="?domain=${model.domain}&date=${model.date}&ip=${model.ipAddress}"/>
			<tr>
				<th class="left"><a href="${urlPrefix}&sort=type">Type</a></th>
				<th class="right"><a href="${urlPrefix}&sort=total">Total</a></th>
				<th class="right"><a href="${urlPrefix}&sort=failure">Failure</a></th>
				<th class="right"><a href="${urlPrefix}&sort=failurePercent">Failure%</a></th>
				<th class="right">Sample Link</th>
				<th class="right"><a href="${urlPrefix}&sort=min">Min</a>(ms)</th>
				<th class="right"><a href="${urlPrefix}&sort=max">Max</a>(ms)</th>
				<th class="right"><a href="${urlPrefix}&sort=avg">Avg</a>(ms)</th>
				<th class="right"><a href="${urlPrefix}&sort=95line">95Line</a>(ms)</th>
				<th class="right"><a href="${urlPrefix}&sort=99line">99.9Line</a>(ms)</th>
				<th class="right"><a href="${urlPrefix}&sort=std">Std</a>(ms)</th>
				<th class="right"><a href="${urlPrefix}&sort=total">QPS</a></th>
			</tr>
			<c:forEach var="item" items="${model.displayTypeReport.results}" varStatus="status">
				<c:set var="e" value="${item.detail}"/>
				<c:set var="lastIndex" value="${status.index}"/>
				<tr class=" right">
					<td class="left"><a href="?op=graphs&domain=${report.domain}&date=${model.date}&ip=${model.ipAddress}&type=${item.type}" class="graph_link" data-status="${status.index}">[:: show ::]</a>
					&nbsp;&nbsp;<a href="?domain=${report.domain}&date=${model.date}&ip=${model.ipAddress}&type=${item.type}"> ${item.detail.id}</a></td>
					<td>${w:format(e.totalCount,'#,###,###,###,##0')}</td>
					<td>${w:format(e.failCount,'#,###,###,###,##0')}</td>
					<td>&nbsp;${w:format(e.failPercent/100,'0.0000%')}</td>
					<td><a href="/cat/r/m/${empty e.failMessageUrl ? e.successMessageUrl : e.failMessageUrl}?domain=${model.domain}">Log View</a></td>
					<td>${w:format(e.min,'###,##0.#')}</td>
					<td>${w:format(e.max,'###,##0.#')}</td>
					<td>${w:format(e.avg,'###,##0.0')}</td>
					<td>${w:format(e.line95Value,'###,##0.0')}</td>
					<td>${w:format(e.line99Value,'###,##0.0')}</td>
					<td>${w:format(e.std,'###,##0.0')}</td>
					<td>${w:format(e.tps,'###,##0.0')}</td>
				</tr>
				<tr class="graphs"><td colspan="13" style="display:none"><div id="${status.index}" style="display:none"></div></td></tr>
				<tr style="display:none"></tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<c:set var="urlPrefix" value="?domain=${model.domain}&date=${model.date}&ip=${model.ipAddress}&type=${payload.encodedType}&queryname=${model.queryName}"/>
			<tr><th class="left" colspan="13"><input type="text" name="queryname" id="queryname" size="40" value="${model.queryName}">
		    <input  class="btn btn-primary  btn-sm"  value="Filter" onclick="selectByName('${model.date}','${model.domain}','${model.ipAddress}','${payload.type}')" type="submit">
			支持多个字符串查询，例如sql|url|task，查询结果为包含任一sql、url、task的列。
			</th></tr>
			<tr>
			<th  style="text-align: left;"><a href="?op=graphs&domain=${report.domain}&date=${model.date}&ip=${model.ipAddress}&type=${payload.encodedType}" class="graph_link" data-status="-1">[:: show ::]</a>
			<a href="?domain=${model.domain}&date=${model.date}&ip=${model.ipAddress}&type=${payload.encodedType}&sort=type&queryname=${model.queryName}">Name</a></th>
			<th class="right"><a href="${urlPrefix}&sort=total">Total</a></th>
			<th class="right"><a href="${urlPrefix}&sort=failure">Failure</a></th>
			<th class="right"><a href="${urlPrefix}&sort=failurePercent">Failure%</a></th>
			<th class="right">Sample Link</th>
			<th class="right"><a href="${urlPrefix}&sort=min">Min</a>(ms)</th>
			<th class="right"><a href="${urlPrefix}&sort=max">Max</a>(ms)</th>
			<th class="right"><a href="${urlPrefix}&sort=avg">Avg</a>(ms)</th>
			<th class="right"><a href="${urlPrefix}&sort=95line">95Line</a>(ms)</th>
			<th class="right"><a href="${urlPrefix}&sort=99line">99.9Line</a>(ms)</th>
			<th class="right"><a href="${urlPrefix}&sort=std">Std</a>(ms)</th>
			<th class="right"><a href="${urlPrefix}&sort=total">QPS</a></th>
			<th class="right"><a href="${urlPrefix}&sort=total">Percent%</a></th></tr>
			<tr class="graphs"><td colspan="13" style="display:none"><div id="-1" style="display:none"></div></td></tr>
			<c:forEach var="item" items="${model.displayNameReport.results}" varStatus="status">
				<c:set var="e" value="${item.detail}"/>
				<c:set var="lastIndex" value="${status.index}"/>
				<tr class=" right">
					<c:choose>
						<c:when test="${status.index > 0}">
							<td class="left longText" style="white-space:normal">
							<a href="?op=graphs&domain=${report.domain}&date=${model.date}&ip=${model.ipAddress}&type=${payload.encodedType}&name=${item.name}" class="graph_link" data-status="${status.index}">[:: show ::]</a> 
							&nbsp;&nbsp;${w:shorten(e.id, 120)}</td>
						</c:when>
						<c:otherwise>
							<td class="center" style="white-space:normal">${w:shorten(e.id, 120)}</td>
						</c:otherwise>
					</c:choose>
					<td>${w:format(e.totalCount,'#,###,###,###,##0')}</td>
					<td>${w:format(e.failCount,'#,###,###,###,##0')}</td>
					<td>&nbsp;${w:format(e.failPercent/100,'0.0000%')}</td>
					<td class="center"><a href="/cat/r/m/${empty e.failMessageUrl ? e.successMessageUrl : e.failMessageUrl}?domain=${model.domain}">Log View</a></td>
					<td>${w:format(e.min,'###,##0.#')}</td>
					<td>${w:format(e.max,'###,##0.#')}</td>
					<td>${w:format(e.avg,'###,##0.0')}</td>
					<c:choose>
						<c:when test="${status.index > 0}">
							<td>${w:format(e.line95Value,'###,##0.0')}</td>
							<td>${w:format(e.line99Value,'###,##0.0')}</td>
						</c:when>
						<c:otherwise>
							<td class="center">-</td>
							<td class="center">-</td>
						</c:otherwise>
					</c:choose>
					<td>${w:format(e.std,'###,##0.0')}</td>
					<td>${w:format(e.tps,'###,##0.0')}</td>
					<td>${w:format(e.totalPercent,'0.00%')}</td>
				</tr>
				<tr class="	"><td colspan="13" style="display:none"><div id="${status.index}" style="display:none"></div></td></tr>
				<tr></tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</table>
<font color="white">${lastIndex}</font>
<script src="${model.webapp}/js/transaction.js"></script>
<c:choose>
	<c:when test="${not empty payload.type}">
		<table>
			<tr>
				<td><div id="transactionGraph" class="pieChart"></div>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			var data = ${model.pieChart};
			graphPieChart(document.getElementById('transactionGraph'), data);
		</script>
	</c:when>
</c:choose>
</jsp:body>
</a:report>
