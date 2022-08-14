WORKERS = {}
WORKERS_QUOTA = 0.5

local function canProcess()
    local exp1 = (math.max(quotaTotalAverage(), quotaTotalUsed()) + (quotaTotalUsed() - math.max(quotaTotalAverage(), quotaTotalUsed())) * 0.01) / quotaMax() < WORKERS_QUOTA
    local exp2 = math.max(quotaTotalAverage(), quotaTotalUsed()) < quotaMax() * WORKERS_QUOTA

    return exp1 and exp2
end

local function execWorker(worker)
    local status

    while canProcess() do
        status = worker()

        if status == 1 or status == 2 then
            break
        end
    end

    return status
end

local function procWorkers()
    local i = 1
    while i <= #WORKERS do
        local status = execWorker(WORKERS[i])

        if status == 2 then
            table.remove(WORKERS, i)
        elseif status == 1 then
            i = i + 1
        else
            break
        end
    end

    if #WORKERS == 0 then
        hook.remove("think", "workers_think")
    end
end

function addWorker(worker)
    local status = execWorker(worker)

    if status ~= 2 then
        if #WORKERS == 0 then
            hook.add("think", "workers_think", procWorkers)
        end

        WORKERS[#WORKERS + 1] = worker
    end
end
